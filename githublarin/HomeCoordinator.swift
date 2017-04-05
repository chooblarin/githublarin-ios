import UIKit

class HomeCoordinator: Coordinator {

    func start() {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}
