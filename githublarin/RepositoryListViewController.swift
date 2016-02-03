//
//  ViewController.swift
//  githublarin
//
//  Created by Sota Hatakeyama on 2016/01/28.
//  Copyright © 2016年 chooblarin. All rights reserved.
//

import UIKit
import RxSwift
import Gloss

class RepositoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var repositoryViewController: RepositoryViewController!

    var repositories = [Repository]() {
        didSet { self.tableView.reloadData() }
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard: UIStoryboard = UIStoryboard(name: "Repository", bundle: NSBundle.mainBundle())
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController {
            repositoryViewController = navigationController.viewControllers.first as! RepositoryViewController
        }

        tableView.dataSource = self
        tableView.delegate = self
        loadRepository()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "RepositoryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! RepositoryTableViewCell
        let repository = repositories[indexPath.row]
        cell.viewModel = repository
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repository = repositories[indexPath.row]
        repositoryViewController?.repository = repository
        self.navigationController?.pushViewController(repositoryViewController!, animated: true)
    }

    func loadRepository() {
        GitHubAPIClient.sharedInstance.searchRepository("RxJava")
            .observeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .subscribeNext { anyobjects -> Void in
                anyobjects.map({ anyobject -> Repository? in
                    let json = anyobject as! JSON
                    return Repository(json: json)
                }).forEach({ repository -> () in
                    if let repository = repository {
                        self.repositories.append(repository)
                    }
                })
            }.addDisposableTo(self.disposeBag)
    }
}
