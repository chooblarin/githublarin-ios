import UIKit

import RxSwift

class AuthCoordinator: Coordinator {

    var user = PublishSubject<User>()
    let disposeBag = DisposeBag()

    weak var delegate: AuthCoordinatorDelegate?

    func start() {
        let loginViewController = LoginViewController(user: user)
        navigationController?.pushViewController(loginViewController, animated: true)

        user.subscribe(
            onNext: { [unowned self] (user: User) in
                self.navigationController?.popViewController(animated: true)
                self.delegate?.didSignIn(authCoordinator: self)
            },
            onError: { (error: Error) in
                debugPrint(error)
            }).addDisposableTo(disposeBag)
    }
}

protocol AuthCoordinatorDelegate: class {
    func didSignIn(authCoordinator: AuthCoordinator)
}
