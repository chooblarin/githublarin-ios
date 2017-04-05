import UIKit

import RxSwift

class LoginViewController: UIViewController {

  class TextFieldContainer: UIView, Shakable {}

  // MARK: - Properties
  var user = PublishSubject<User>()
  let disposeBag = DisposeBag()
  let apiClient = GitHubAPIClient.sharedInstance

  var usernameTextField: UITextField = {
    let textField = UITextField()
    textField.keyboardType = .asciiCapable
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.placeholder = "Username"
    return textField
  }()
  var passwordTextField: UITextField = {
    let textField = UITextField()
    textField.keyboardType = .asciiCapable
    textField.isSecureTextEntry = true
    textField.placeholder = "Password"
    return textField
  }()
  var signinButton: UIButton = {
    let button = UIButton(type: UIButtonType.system)
    button.setTitle("Sign in", for: UIControlState())
    return button
  }()

  init(user: PublishSubject<User>) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white

    let welcomeLabel = UILabel()
    welcomeLabel.text = "GitHublarin"
    welcomeLabel.font = UIFont.boldSystemFont(ofSize: 24.0)

    let container = TextFieldContainer()
    container.backgroundColor = UIColor.white

    welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
    container.translatesAutoresizingMaskIntoConstraints = false
    usernameTextField.translatesAutoresizingMaskIntoConstraints = false
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    signinButton.translatesAutoresizingMaskIntoConstraints = false

    container.addSubview(usernameTextField)
    container.addSubview(passwordTextField)
    view.addSubview(welcomeLabel)
    view.addSubview(container)
    view.addSubview(signinButton)

    let views: [String: AnyObject] = [
      "welcomeLabel": welcomeLabel,
      "container": container,
      "username": usernameTextField,
      "password": passwordTextField,
      "signin": signinButton,
    ]
    view.addConstraint(NSLayoutConstraint(
      item: container,
      attribute: .centerY,
      relatedBy: .equal,
      toItem: view,
      attribute: .centerY,
      multiplier: 1.0,
      constant: -64.0))
    var constraints = [NSLayoutConstraint]()
    constraints += NSLayoutConstraint.constraints(
      withVisualFormat: "V:[welcomeLabel]-92-[container]-64-[signin]",
      options: [.alignAllCenterX],
      metrics: nil,
      views: views)
    constraints += NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-32-[container]-32-|",
      options: [],
      metrics: nil,
      views: views)
    constraints += NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[username]|",
      options: [],
      metrics: nil,
      views: views)
    constraints += NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[password]|",
      options: [],
      metrics: nil,
      views: views)
    constraints += NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[username]-[password]|",
      options: [],
      metrics: nil,
      views: views)
    NSLayoutConstraint.activate(constraints)

    let username = usernameTextField.rx.text
    let password = passwordTextField.rx.text

    signinButton.isEnabled = false
    let usernameValidation = username.map { (text: String?) -> Bool in
      if let str = text, !str.isEmpty {
        return true
      } else {
        return false
      }}.shareReplay(1)
    let passwordValidation = password.map { (text: String?) -> Bool in
      if let str = text, !str.isEmpty {
        return true
      } else {
        return false
      }}.shareReplay(1)
    let enableButton = Observable.combineLatest(usernameValidation, passwordValidation) { $0 && $1 }
    enableButton.bindTo(signinButton.rx.isEnabled).addDisposableTo(disposeBag)

    signinButton.rx.tap.shareReplay(1)
      .flatMap { self.apiClient.login(
        username: self.usernameTextField.text!,
        password: self.passwordTextField.text!)
      }
      .bindTo(user)
      .addDisposableTo(disposeBag)
  }
}
