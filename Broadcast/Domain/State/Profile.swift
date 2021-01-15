//
//  Profile.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import Foundation

enum CurrencyCode: String, Codable {
    case eur = "EUR"
    case usd = "USD"
    case cad = "CAD"
    case gdp = "GDP"
}

struct Profile : Equatable, Codable {
    let firstName: String?
    let lastName: String?
    var biography: String?
    var displayName: String
    let handle: String
    let subscriberCount: Int
    let profileImageUrl: String?
    let trailerThumbnailUrl: String?
    let trailerVideoUrl: String?
    
    struct StripeAccount : Equatable, Codable {
        let accountId: String?
        let productId: String?
        let currencyCode: CurrencyCode?
        
        let price: Int?
        let balance: Int?
        let totalVolume: Int?
        
        let paymentsEnabled: Bool
        let payoutsEnabled: Bool
    }
    
    let stripeAccount: StripeAccount
}
