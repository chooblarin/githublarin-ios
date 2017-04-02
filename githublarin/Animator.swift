import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    let distance: CGFloat = 70.0
    let duration = 0.3
    var presenting = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
              let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }

        if presenting {
            presentTransition(transitionContext, toView: toViewController.view, fromView: fromViewController.view)
        } else {
            dismissTransition(transitionContext, toView: toViewController.view, fromView: fromViewController.view)
        }
    }

    func presentTransition(_ transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {

        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, aboveSubview: fromView)

        toView.frame = toView.frame.offsetBy(dx: containerView.frame.size.width, dy: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
            delay: 0.05,
            options: UIViewAnimationOptions(),
            animations: {
                fromView.frame = fromView.frame.offsetBy(dx: -self.distance, dy: 0)
                fromView.alpha = 0.7

                toView.frame = containerView.frame
            },
            completion: { finished in
                fromView.frame = fromView.frame.offsetBy(dx: self.distance, dy: 0)
                transitionContext.completeTransition(true)
            }
        )
    }

    func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {

        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView)

        toView.frame = toView.frame.offsetBy(dx: -self.distance, dy: 0)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:  0, options: UIViewAnimationOptions(),
            animations: {
                fromView.frame = fromView.frame.offsetBy(dx: containerView.frame.size.width, dy: 0)
                toView.frame = toView.frame.offsetBy(dx: self.distance, dy: 0)
                toView.alpha = 1.0
            },
            completion: { (finished) -> Void in
                transitionContext.completeTransition(true)
            }
        )
    }
}
