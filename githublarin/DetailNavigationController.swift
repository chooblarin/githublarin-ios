import UIKit

class DetailNavigationController: UINavigationController, UIViewControllerTransitioningDelegate {

    // MARK: - Properties
    let animator = Animator()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
}
