import UIKit

class DetailWebViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var webView: UIWebView!

    // MARK: - Properties
    var repository: Repository?
    var feed: Feed?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        var htmlUrlString: String?
        if let feed = feed {
            htmlUrlString = feed.link
        }
        if let repository = repository {
            htmlUrlString = repository.htmlUrl
        }

        guard let htmlUrl = htmlUrlString,
            let url = NSURL(string: htmlUrl) else { return }
        webView.loadRequest(NSURLRequest(URL: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IBActions

    @IBAction func dismiss(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
