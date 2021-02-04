//
//  URLAPIQueryStringRequest.swift
//  Broadcast
//
//  Created by Piotr Suwara on 9/12/20.
//

import Foundation
import RxAlamofire
import Alamofire

/// Create a URL Request for RxAlamofire that accepts Query string like parameters
/// that are created as text inside the httpbody
class URLAPIQueryStringRequest : URLRequestConvertible {
    
    let method: HTTPMethod
    let url: URL
    let queryString: String
    let headers: Dictionary<String, String>
    
    init(_ method: HTTPMethod,
         _ url: URL,
         parameters: Dictionary<String, String>,
         headers: Dictionary<String, String>) {
        self.queryString = parameters.queryString
        self.method = method
        self.url = url
        self.headers = headers
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        
        request.headers = HTTPHeaders(headers)
        request.httpMethod = method.rawValue
        request.httpBody = queryString.data(using: .utf8)
        
        return request
    }
}
