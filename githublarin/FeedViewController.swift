import UIKit
import RxSwift

class FeedViewController: UITableViewController {

    // MARK: - Properties

    let disposeBag: DisposeBag = DisposeBag()
    let apiClient: GitHubAPIClient = GitHubAPIClient.sharedInstance
    let cellIdentifier = "FeedCell"
    var feeds = [Feed]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: "loadFeeds", forControlEvents: UIControlEvents.ValueChanged)

        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self

        loadFeeds()
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! FeedCell
        let feed = feeds[indexPath.row]
        cell.title.text = feed.title
        return cell
    }

    func loadFeeds() {
        apiClient.feeds()
            .toArray()
            .subscribe { event in
                switch event {
                case .Next(let feeds):
                    self.feeds = feeds
                case .Error(_):
                    self.refreshControl?.endRefreshing()
                case .Completed:
                    self.refreshControl?.endRefreshing()
                }
            }
            .addDisposableTo(disposeBag)
    }

    func selected() {
    }
}
