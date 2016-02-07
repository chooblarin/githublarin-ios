import UIKit
import RxSwift

class GistListViewController: UIViewController, UITableViewDataSource {

    // MARK: - Properties

    var gists = [Gist]() {
        didSet {
            tableView.reloadData()
        }
    }
    let apiClient = GitHubAPIClient.sharedInstance
    let disposeBag = DisposeBag()
    let cellIdentifier = "GistCell"

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension

        apiClient.gists().subscribeNext {
            self.gists = $0
        }.addDisposableTo(disposeBag)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "ShowGistDetail" == segue.identifier {
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailWebViewController = navigationController.viewControllers.first as! DetailWebViewController
            let gistCell = sender as! GistCell
            detailWebViewController.gist = gistCell.gist
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GistCell
        cell.gist = gists[indexPath.row]
        return cell
    }

    func selected() {
    }
}
