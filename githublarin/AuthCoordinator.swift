import UIKit

class AuthCoordinator: Coordinator {

    func start() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}
