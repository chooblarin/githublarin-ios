import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // navigation bar style
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor(hex: 0xCDDC39)
        navigationBarAppearance.barTintColor = UIColor(hex: 0x330089)
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        // status bar style
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

        Realm.Configuration.defaultConfiguration = realmConfig()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let sessionManager = SessionManager.sharedInstance
        let realm = try! Realm()
        if let _ = sessionManager.getSession(realm) {
            let storyboard = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
            self.window?.rootViewController = storyboard.instantiateInitialViewController() as! HomeViewController

        } else {
            self.window?.rootViewController = LoginViewController()
        }
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    private func realmConfig() -> Realm.Configuration {
        var config = Realm.Configuration()
        let path = NSURL.fileURLWithPath(config.path!)
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("githublarin")
            .URLByAppendingPathExtension("realm")
            .path
        config.path = path
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
            // do nothing yet
        }
        return config
    }
}

func commonError(error: String, location: String = "\(__FILE__):\(__LINE__)") -> NSError {
    return NSError(domain: "CommonError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}
