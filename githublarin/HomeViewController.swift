import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        var viewControllers = [UIViewController]()
        let feedListStoryboard = UIStoryboard(name: "FeedList", bundle: NSBundle.mainBundle())
        let gistListStoryboard = UIStoryboard(name: "GistList", bundle: NSBundle.mainBundle())
        let notificationsStoryboard = UIStoryboard(name: "Notifications", bundle: NSBundle.mainBundle())
        let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: NSBundle.mainBundle())
        viewControllers.append(feedListStoryboard.instantiateInitialViewController()!)
        viewControllers.append(gistListStoryboard.instantiateInitialViewController()!)
        viewControllers.append(notificationsStoryboard.instantiateInitialViewController()!)
        viewControllers.append(myPageStoryboard.instantiateInitialViewController()!)
        self.viewControllers = viewControllers

        self.delegate = self
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        guard let navigationController = viewController as? UINavigationController else { return }
        switch navigationController.viewControllers.first! {
        case let feedViewController as FeedViewController:
            feedViewController.selected()
        case let gistViewController as GistListViewController:
            gistViewController.selected()
        default:
            print("Error") // TODO: - handle error
        }
    }
}
