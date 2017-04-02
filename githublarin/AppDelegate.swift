import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // navigation bar style
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor(hex: 0xCDDC39)
        navigationBarAppearance.barTintColor = UIColor(hex: 0x330089)
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]

        // status bar style
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        Realm.Configuration.defaultConfiguration = realmConfig()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let sessionManager = SessionManager.sharedInstance
        let realm = try! Realm()
        if let _ = sessionManager.getSession(realm) {
            self.window?.rootViewController = HomeViewController()

        } else {
            self.window?.rootViewController = LoginViewController()
        }
        self.window?.makeKeyAndVisible()
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

