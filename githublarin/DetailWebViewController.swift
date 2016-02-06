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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
