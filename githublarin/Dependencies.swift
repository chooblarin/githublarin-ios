//
//  Dependencies.swift
//  githublarin
//
//  Created by Sota Hatakeyama on 2016/01/31.
//  Copyright © 2016年 chooblarin. All rights reserved.
//

import Foundation
import RxSwift

class Dependencies {

    static let sharedDependencies = Dependencies() // Singleton

    let backgroundWorkScheduler: ImmediateSchedulerType
    let mainScheduler: SerialDispatchQueueScheduler

    private init() {
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = NSQualityOfService.UserInitiated
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        mainScheduler = MainScheduler.instance
    }
}
