import UIKit
import RxSwift

class FeedViewController: UITableViewController {

    static func create() -> UIViewController {
        let viewController = FeedViewController(style: .Plain)
        viewController.title = "Feed"
        viewController.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

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
        refreshControl?.addTarget(
            self,
            action: #selector(FeedViewController.loadFeeds),
            forControlEvents: UIControlEvents.ValueChanged)

        tableView.register(FeedCell.self)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self

        loadFeeds()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "ShowFeedDetail" == segue.identifier {
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailWebViewController = navigationController.viewControllers.first as! DetailWebViewController
            let feedCell = sender as! FeedCell
            detailWebViewController.feed = feedCell.feed
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FeedCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.feed = feeds[indexPath.row]
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
}
