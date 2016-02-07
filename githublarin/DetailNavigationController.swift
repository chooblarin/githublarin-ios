import UIKit

class DetailNavigationController: UINavigationController, UIViewControllerTransitioningDelegate {

    // MARK: - Properties
    let animator = Animator()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
}
