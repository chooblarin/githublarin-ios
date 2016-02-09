import UIKit
import RxSwift

class GistListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var myGistsContainer: UIView!
    @IBOutlet weak var starredGistsConainer: UIView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func selected() {
    }

    // MARK: - IBActions

    @IBAction func changeSegment(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // My Gist
            myGistsContainer.hidden = false
            starredGistsConainer.hidden = true
            
        case 1: // Starred Gist
            myGistsContainer.hidden = true
            starredGistsConainer.hidden = false

        default: break
        }
    }
}
