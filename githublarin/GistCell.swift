import UIKit
import Kingfisher

class GistCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Properties

    var gist: Gist? {
        didSet {
            if let avatarUrlString = gist?.owner.avatarUrl,
                let avatarUrl = NSURL(string: avatarUrlString) {
                    ownerImageView.kf_setImageWithURL(avatarUrl)
            }
            nameLabel.text = gist?.id
        }
    }
}
