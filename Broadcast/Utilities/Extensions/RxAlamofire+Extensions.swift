//
//  RxAlamofire+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 7/1/21.
//

import RxAlamofire
import RxSwift
import Alamofire

/// Support upload request validation observables
public extension ObservableType where Element == UploadRequest {
  func validate<S: Sequence>(statusCode: S) -> Observable<Element> where S.Element == Int {
    return map { $0.validate(statusCode: statusCode) }
  }

  func validate() -> Observable<Element> {
    return map { $0.validate() }
  }

  func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Observable<Element> where S.Iterator.Element == String {
    return map { $0.validate(contentType: acceptableContentTypes) }
  }

  func validate(_ validation: @escaping DataRequest.Validation) -> Observable<Element> {
    return map { $0.validate(validation) }
  }
}
