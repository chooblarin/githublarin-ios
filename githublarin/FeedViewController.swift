import UIKit
import RxSwift

class FeedViewController: UIViewController {

    var disposeBag: DisposeBag = DisposeBag()
    let apiClient: GitHubAPIClient = GitHubAPIClient.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient.feeds()
            .subscribeNext { feed in
                print(feed.title)
            }
            .addDisposableTo(disposeBag)
    }

    func selected() {
    }
}
