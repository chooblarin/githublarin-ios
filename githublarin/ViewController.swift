//
//  ViewController.swift
//  githublarin
//
//  Created by Sota Hatakeyama on 2016/01/28.
//  Copyright © 2016年 chooblarin. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup aqfter loading the view, typically from a nib.
        Alamofire.request(.GET, "https://api.github.com/repos/vmg/redcarpet/issues?state=closed")
            .responseJSON() {response in
                if response.result.isSuccess {
                    print(response.result.value)
                }
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
