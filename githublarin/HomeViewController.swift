import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var viewControllers = [UIViewController]()
        let gistStoryboard = UIStoryboard(name: "GistList", bundle: Bundle.main)
        viewControllers.append(FeedViewController.create())
        viewControllers.append(gistStoryboard.instantiateInitialViewController()!)
        self.viewControllers = viewControllers
    }
}
