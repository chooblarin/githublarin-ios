import UIKit

class DetailWebViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var webView: UIWebView!

    // MARK: - Properties
    var repository: Repository?
    var feed: Feed?
    var gist: Gist?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        var htmlUrlString: String?
        if let feed = feed {
            htmlUrlString = feed.link
        }
        if let repository = repository {
            htmlUrlString = repository.htmlUrl
        }
        if let gist = gist {
            htmlUrlString = gist.htmlUrl
        }

        guard let htmlUrl = htmlUrlString,
            let url = URL(string: htmlUrl) else { return }
        webView.loadRequest(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IBActions

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
