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

        apiClient.gists().subscribeNext {
            self.gists = $0
        }.addDisposableTo(disposeBag)
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
