import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    let distance: CGFloat = 70.0
    let duration = 0.3
    var presenting = false

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
              let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }

        if presenting {
            presentTransition(transitionContext, toView: toViewController.view, fromView: fromViewController.view)
        } else {
            dismissTransition(transitionContext, toView: toViewController.view, fromView: fromViewController.view)
        }
    }

    func presentTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        guard let containerView = transitionContext.containerView() else { return }
        containerView.insertSubview(toView, aboveSubview: fromView)

        toView.frame = CGRectOffset(toView.frame, containerView.frame.size.width, 0)
        UIView.animateWithDuration(transitionDuration(transitionContext),
            delay: 0.05,
            options: .CurveEaseInOut,
            animations: {
                fromView.frame = CGRectOffset(fromView.frame, -self.distance, 0)
                fromView.alpha = 0.7

                toView.frame = containerView.frame
            },
            completion: { finished in
                fromView.frame = CGRectOffset(fromView.frame, self.distance, 0)
                transitionContext.completeTransition(true)
            }
        )
    }

    func dismissTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        guard let containerView = transitionContext.containerView() else { return }
        containerView.insertSubview(toView, belowSubview: fromView)

        toView.frame = CGRectOffset(toView.frame, -self.distance, 0)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay:  0, options: .CurveEaseInOut,
            animations: {
                fromView.frame = CGRectOffset(fromView.frame, containerView.frame.size.width, 0)
                toView.frame = CGRectOffset(toView.frame, self.distance, 0)
                toView.alpha = 1.0
            },
            completion: { (finished) -> Void in
                transitionContext.completeTransition(true)
            }
        )
    }
}
