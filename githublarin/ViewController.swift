//
//  ViewController.swift
//  githublarin
//
//  Created by Sota Hatakeyama on 2016/01/28.
//  Copyright © 2016年 chooblarin. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GitHubAPIClient.sharedInstance.searchRepository("RxJava")
        GitHubAPIClient.sharedInstance.demo()
            .observeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .subscribeNext { (object) -> Void in
                print(object)
            }.addDisposableTo(self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
