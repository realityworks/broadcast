//
//  Profile.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import Foundation

struct Profile : Equatable, Codable {
    let firstName: String
    let lastName: String
    let biography: String
    let displayName: String
    let subscribers: Int
    let thumbnailUrl: String?
    let trailerUrl: String?
    
    struct StripeAccount : Equatable, Codable {
        let name: String
        let id: String
        let currency: String
        
        let pricing: Float
        let balance: Float
        let totalVolume: Float
        
        let paymentsDisabled: Bool
        let payoutsDisabled: Bool
    }
    
    let stripeAccount: StripeAccount
}
