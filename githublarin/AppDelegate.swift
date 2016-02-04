import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let sessionManager = SessionManager.sharedInstance
        let realm = try! Realm()
        if let _ = sessionManager.getSession(realm) {
            let storyboard = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
            self.window?.rootViewController = storyboard.instantiateInitialViewController() as! HomeViewController

        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
            self.window?.rootViewController = storyboard.instantiateInitialViewController() as! LoginViewController
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
}

func commonError(error: String, location: String = "\(__FILE__):\(__LINE__)") -> NSError {
    return NSError(domain: "CommonError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}
