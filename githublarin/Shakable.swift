import UIKit

protocol Shakable {
}

extension Shakable where Self: UIView {

    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        let centerX = self.center.x
        let centerY = self.center.y
        animation.fromValue = NSValue(CGPoint: CGPointMake(centerX - 4, centerY))
        animation.toValue = NSValue(CGPoint: CGPointMake(centerX + 4, centerY))
        self.layer.addAnimation(animation, forKey: "position")
    }
}
