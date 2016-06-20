import UIKit
import RxSwift

class TextFieldContainer: UIView {}
extension TextFieldContainer: Shakable {}

class LoginViewController: UIViewController {

    // MARK: - Properties

    let disposeBag = DisposeBag()
    let apiClient = GitHubAPIClient.sharedInstance

    var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        return textField
    }()
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        return textField
    }()
    var signinButton: UIButton = {
        let button = UIButton(type: UIButtonType.System)
        button.setTitle("Sign in", forState: .Normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        let welcomeLabel = UILabel()
        welcomeLabel.text = "GitHublarin"
        welcomeLabel.font = UIFont.boldSystemFontOfSize(24.0)

        let container = TextFieldContainer()
        container.backgroundColor = UIColor.whiteColor()

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        signinButton.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(usernameTextField)
        container.addSubview(passwordTextField)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(container)
        self.view.addSubview(signinButton)

        let views: [String: AnyObject] = [
            "welcomeLabel": welcomeLabel,
            "container": container,
            "username": usernameTextField,
            "password": passwordTextField,
            "signin": signinButton,
        ]
        view.addConstraint(NSLayoutConstraint(
            item: container,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: -64.0))
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[welcomeLabel]-92-[container]-64-[signin]",
            options: [.AlignAllCenterX],
            metrics: nil,
            views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-32-[container]-32-|",
            options: [],
            metrics: nil,
            views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[username]|",
            options: [],
            metrics: nil,
            views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[password]|",
            options: [],
            metrics: nil,
            views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[username]-[password]|",
            options: [],
            metrics: nil,
            views: views)
        NSLayoutConstraint.activateConstraints(constraints)

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
                    container.shake()
                    print(error)

                case .Completed: break
                }
            }.addDisposableTo(disposeBag)
    }
}
