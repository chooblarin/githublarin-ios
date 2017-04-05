import UIKit

class Coordinator {

    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
