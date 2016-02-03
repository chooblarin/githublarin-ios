import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    // MARK: - UITabBarControllerDelegate
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        guard let navigationController = viewController as? UINavigationController else { return }
        switch navigationController.viewControllers.first! {
        case let feedViewController as FeedViewController:
            feedViewController.selected()
        case let gistViewController as GistViewController:
            gistViewController.selected()
        default:
            print("Error") // TODO: - handle error
        }
    }
}
