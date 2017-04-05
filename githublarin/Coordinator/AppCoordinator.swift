import UIKit

import RealmSwift

class AppCoordinator: Coordinator {

    func start() {
        let realm = try! Realm()
        if let _ = SessionManager.sharedInstance.getSession(realm) {
            showHome()
        } else {
            showLogin()
        }
    }

    func showHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
        addChild(homeCoordinator)
    }

    func showLogin() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.start()
        addChild(authCoordinator)
    }
}

// MARK: AuthCoordinatorDelegate

extension AppCoordinator: AuthCoordinatorDelegate {

    func didSignIn(authCoordinator: AuthCoordinator) {
        removeChild(authCoordinator)
        showHome()
    }
}
