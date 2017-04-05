import UIKit

class Coordinator {

    var childCoordinators: [Coordinator] = []

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

extension Coordinator {

    func addChild(_ childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }

    func removeChild(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}
