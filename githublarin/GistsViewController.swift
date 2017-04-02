import UIKit
import RxSwift

class GistsViewController: UIViewController, UITableViewDataSource {

    // MARK: - Properties
    
    var gists = [Gist]() {
        didSet {
            tableView.reloadData()
        }
    }
    let apiClient = GitHubAPIClient.sharedInstance
    let disposeBag = DisposeBag()
    let cellIdentifier = "GistCell"

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension

        apiClient.gists().subscribe(
            onNext: { [weak self] (gists: [Gist]) in
                self?.gists = gists
            },
            onError: { (error: Error) in
                debugPrint(error)
            })
            .addDisposableTo(disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "ShowGistDetail" == segue.identifier {
            let navigationController = segue.destination as! UINavigationController
            let detailWebViewController = navigationController.viewControllers.first as! DetailWebViewController
            let gistCell = sender as! GistCell
            detailWebViewController.gist = gistCell.gist
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! GistCell
        cell.gist = gists[indexPath.row]
        return cell
    }
}
