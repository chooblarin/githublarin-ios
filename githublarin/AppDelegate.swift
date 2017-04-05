import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // navigation bar style
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.mainColor
        navigationBarAppearance.tintColor = UIColor.accentColor
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]

        // status bar style
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        Realm.Configuration.defaultConfiguration = realmConfig()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        self.coordinator = coordinator
        window?.makeKeyAndVisible()
        return true
    }

    fileprivate func realmConfig() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
            // do nothing yet
        }
        config.deleteRealmIfMigrationNeeded = false
        return config
    }
}

extension UIColor {
    static var mainColor: UIColor {
        return UIColor(hex: 0x330089)
    }
    static var accentColor: UIColor {
        return UIColor(hex: 0xCDDC39)
    }
    
}
