import UIKit
import Kingfisher

extension FeedCell: ReusableView {}
extension FeedCell: NibLoadableView {}

class FeedCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!

    // MARK: - Properties

    var feed: Feed? {
        didSet {
            if let thumbnailUrlString = feed?.thumbnail,
                let thumbnailUrl = URL(string: thumbnailUrlString) {
                userImageView.kf.setImage(with: thumbnailUrl)
            }
            titleLabel.text = feed?.title
            publishedAtLabel.text = feed?.publishedAt
        }
    }
}
