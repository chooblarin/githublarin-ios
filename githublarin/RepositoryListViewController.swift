import UIKit
import RxSwift
import Gloss

class RepositoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    var repositories = [Repository]() {
        didSet { self.tableView.reloadData() }
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadRepository()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "RepositoryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! RepositoryTableViewCell
        let repository = repositories[indexPath.row]
        cell.viewModel = repository
        return cell
    }

    func loadRepository() {
        GitHubAPIClient.sharedInstance.searchRepository("RxJava")
            .subscribe(
                onNext: { [weak self] (repos: [Repository]) in
                    self?.repositories = repos
                },
                onError: { (error: Error) in
                    debugPrint(error)
                }).addDisposableTo(self.disposeBag)
    }
}
