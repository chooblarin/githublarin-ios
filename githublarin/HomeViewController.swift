import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        var viewControllers = [UIViewController]()
        let feedStoryboard = UIStoryboard(name: "FeedList", bundle: NSBundle.mainBundle())
        let gistStoryboard = UIStoryboard(name: "GistList", bundle: NSBundle.mainBundle())
        viewControllers.append(feedStoryboard.instantiateInitialViewController()!)
        viewControllers.append(gistStoryboard.instantiateInitialViewController()!)
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
