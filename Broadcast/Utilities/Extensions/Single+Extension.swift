//
//  Single+Extension.swift
//  Broadcast
//
//  Created by Piotr Suwara on 10/12/20.
//

import Foundation
import RxSwift

extension Single where Element == (HTTPURLResponse, Data), Trait == SingleTrait {
    func decode<T>(type _: T.Type) -> Single<T> where T: Decodable {
        return flatMap { response, data -> Single<T> in
            let decoder = JSONDecoder()
            do {
                let statusCode = response.statusCode
                switch statusCode {
                case 200...299:
                    let decodedValue = try decoder.decode(T.self, from: data)
                    return .just(decodedValue)
                default:
                    return .error(self.error(from: statusCode, data: data))
                }
            } catch let error as DecodingError {
                return .error(BoomdayError.decoding(error: error))
            }
        }
    }
    
    func emptyReponseBody(_ successCode: [Int] = Array(200...299)) -> Completable {
        return flatMapCompletable { response, data -> Completable in
            if successCode.contains(response.statusCode) {
                return .empty()
            } else {
                return .error(self.error(from: response.statusCode, data: data))
            }
        }
        .catchError { error in
            throw error
        }
    }
    
    private func error(from statusCode: Int, data: Data) -> Error {
        switch statusCode {
        case 404:
            return BoomdayError.apiNotFound
        default:
            return BoomdayError.apiStatusCode(code: statusCode)
        }
    }
}
