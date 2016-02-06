import UIKit
import Kingfisher

class FeedCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!

    // MARK: - Properties

    var feed: Feed? {
        didSet {
            if let thumbnailUrlString = feed?.thumbnail,
                let thumbnailUrl = NSURL(string: thumbnailUrlString) {
                userImageView.kf_setImageWithURL(thumbnailUrl)
            }
            titleLabel.text = feed?.title
            publishedAtLabel.text = feed?.publishedAt
        }
    }
}
