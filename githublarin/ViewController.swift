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

class ViewController: UIViewController, UITableViewDataSource {

    // MARK: - IBOutlets

    @IBOutlet weak var repositoryTableView: UITableView!

    // MARK: - Properties

    var repositories = [Repository]()
    {
        didSet { self.repositoryTableView.reloadData() }
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        repositoryTableView.dataSource = self
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
        let cell = repositoryTableView.dequeueReusableCellWithIdentifier(identifier) as! RepositoryTableViewCell
        let repository = repositories[indexPath.row]
        cell.viewModel = repository
        return cell
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
