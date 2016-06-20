import UIKit

extension UITableView {

    func register<T: UITableViewCell where T: ReusableView, T: NibLoadableView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: T.reusableIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell where T: ReusableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithIdentifier(T.reusableIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(T.reusableIdentifier)")
        }
        return cell
    }
}

protocol ReusableView {}

extension ReusableView where Self: UIView {
    static var reusableIdentifier: String {
        return String(self)
    }
}

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(self)
    }
}
