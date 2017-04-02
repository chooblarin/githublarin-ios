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
        animation.fromValue = NSValue(cgPoint: CGPoint(x: centerX - 4, y: centerY))
        animation.toValue = NSValue(cgPoint: CGPoint(x: centerX + 4, y: centerY))
        self.layer.add(animation, forKey: "position")
    }
}
