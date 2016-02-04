import UIKit
import RxSwift

class LoginViewController: UIViewController {

    // MARK: - Properties
    let disposeBag = DisposeBag()
    let apiClient = GitHubAPIClient.sharedInstance

    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let username = usernameTextField.rx_text
        let password = passwordTextField.rx_text

        signinButton.enabled = false
        let usernameValidation = username.map {!$0.isEmpty}.shareReplay(1)
        let passwordValidation = password.map {!$0.isEmpty}.shareReplay(1)
        let enableButton = Observable.combineLatest(usernameValidation, passwordValidation) { $0 && $1 }
        enableButton.bindTo(signinButton.rx_enabled).addDisposableTo(disposeBag)

        signinButton.rx_tap.shareReplay(1)
            .flatMap { self.apiClient.login(
                username: self.usernameTextField.text!,
                password: self.passwordTextField.text!)
            }
            .subscribe { event -> Void in
                switch event {
                case .Next(_):
                    let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
                    let homeViewController = storyboard.instantiateInitialViewController() as! HomeViewController
                    self.presentViewController(homeViewController, animated: true, completion: nil)

                case .Error(let error):
                    print(error)

                case .Completed: break
                }
            }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
