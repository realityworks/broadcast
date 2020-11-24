//
//  AuthenticateResponse.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/11/20.
//

import Foundation

struct AuthenticateResponse : Decodable {
    let authenticationToken: String
    let refreshToken: String
}
