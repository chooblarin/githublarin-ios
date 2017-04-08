import UIKit
import RxSwift
import SnapKit

class LoginViewController: UIViewController {

  class TextFieldContainer: UIView, Shakable {}

  let welcomeLabel: UILabel = {
    let label = UILabel()
    label.text = "GitHublarin"
    label.font = UIFont.boldSystemFont(ofSize: 24.0)
    return label
  }()
  let container = TextFieldContainer()
  let usernameTextField: UITextField = {
    let textField = UITextField()
    textField.keyboardType = .asciiCapable
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.placeholder = "Username"
    return textField
  }()
  let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.keyboardType = .asciiCapable
    textField.isSecureTextEntry = true
    textField.placeholder = "Password"
    return textField
  }()
  let signinButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign in", for: .normal)
    return button
  }()

  // MARK: - Properties

  var user = PublishSubject<User>()
  let disposeBag = DisposeBag()
  let apiClient = GitHubAPIClient.sharedInstance

  init(user: PublishSubject<User>) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()

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

  private func setupUI() {
    view.backgroundColor = .white
    container.backgroundColor = .white

    container.addSubview(usernameTextField)
    usernameTextField.snp.makeConstraints { make in
      make.top.equalTo(container)
      make.left.equalTo(container)
      make.right.equalTo(container)
    }
    container.addSubview(passwordTextField)
    passwordTextField.snp.makeConstraints { make in
      make.top.equalTo(usernameTextField.snp.bottom).offset(20)
      make.left.equalTo(container)
      make.right.equalTo(container)
      make.bottom.equalTo(container)
    }
    view.addSubview(container)
    container.snp.makeConstraints { make in
      make.centerY.equalTo(view).offset(-64)
      make.left.equalTo(view).offset(40)
      make.right.equalTo(view).offset(-40)
    }
    view.addSubview(welcomeLabel)
    welcomeLabel.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.bottom.equalTo(container.snp.top).offset(-92)
    }
    view.addSubview(signinButton)
    signinButton.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(container.snp.bottom).offset(64)
    }
  }
}
