import UIKit

class RepositoryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starredCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!

    // MARK: Properties

    var viewModel: Repository? {
        didSet {
            guard let viewModel = viewModel else { return }
            fullNameLabel.text = viewModel.fullName
            descriptionLabel.text = viewModel.description
        }
    }
}
