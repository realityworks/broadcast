//
//  Schedulers.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation
import RxSwift

/// Two primary schedulers for main and utility functions used with the RxSwift framework
struct Schedulers {
    let main: SchedulerType
    let utility: SchedulerType
    
    static let standard = Schedulers(main: MainScheduler.instance,
                                     utility: ConcurrentDispatchQueueScheduler(qos: .utility))
}
