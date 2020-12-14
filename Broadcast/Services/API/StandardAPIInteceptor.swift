//
//  StandardAPIInteceptor.swift
//  Broadcast
//
//  Created by Piotr Suwara on 14/12/20.
//

import Foundation
import Alamofire
import RxAlamofire

class StandardAPIInteceptor : Interceptor {
    override func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        print ("Status Code: \(response.statusCode)")
        
        completion(.doNotRetryWithError(error))
        return
    }
}
