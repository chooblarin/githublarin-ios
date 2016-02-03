import UIKit
import RxSwift

class LoginViewController: UIViewController {

    // MARK: - Properties
    let disposeBag = DisposeBag()

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

        signinButton.rx_tap.subscribe { (event) -> Void in
            print(self.usernameTextField.text)
            print(self.passwordTextField.text)
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
