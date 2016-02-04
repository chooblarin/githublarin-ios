import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GitHubAPIClient.sharedInstance.feeds()
    }

    func selected() {
    }
}
