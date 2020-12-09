//
//  URLAPIQueryStringRequest.swift
//  Broadcast
//
//  Created by Piotr Suwara on 9/12/20.
//

import Foundation
import RxAlamofire
import Alamofire

class URLAPIQueryStringRequest : URLRequestConvertible {
    
    let method: HTTPMethod
    let url: URL
    let queryString: String
    
    init(_ method: HTTPMethod, _ url: URL, parameters: Dictionary<String, String>) {
        self.queryString = parameters.queryString
        self.method = method
        self.url = url
    }
    
    func asURLRequest() throws -> URLRequest {
        let request = URLRequest()
        return request
    }
}
