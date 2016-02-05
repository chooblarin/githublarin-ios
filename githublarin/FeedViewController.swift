import UIKit
import RxSwift

class FeedViewController: UIViewController, UITableViewDataSource {

    // MARK: - Properties

    let disposeBag: DisposeBag = DisposeBag()
    let apiClient: GitHubAPIClient = GitHubAPIClient.sharedInstance
    let cellIdentifier = "FeedCell"
    var feeds = [Feed]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self

        apiClient.feeds()
            .toArray()
            .subscribeNext { feeds in
                self.feeds += feeds
            }
            .addDisposableTo(disposeBag)
    }

    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! FeedCell
        let feed = feeds[indexPath.row]
        cell.title.text = feed.title
        return cell
    }

    func selected() {
    }
}
