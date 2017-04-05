import UIKit

import RealmSwift

class AppCoordinator: Coordinator {

    func start() {
        let realm = try! Realm()
        if let _ = SessionManager.sharedInstance.getSession(realm) {
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)

        } else {
            let authCoordinator = AuthCoordinator(navigationController: navigationController)
            authCoordinator.start()
            childCoordinators.append(authCoordinator)
        }
    }
}
