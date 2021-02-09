//
//  Profile.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import Foundation

enum CurrencyCode: String, Codable {
    case eur = "eur"
    case usd = "usd"
    case cad = "cad"
    case gbp = "gbp"
}

struct Profile : Equatable, Codable {
    let firstName: String?
    let lastName: String?
    var biography: String?
    var displayName: String
    let handle: String
    let email: String?
    let subscriberCount: Int
    var profileImageUrl: String?
    var trailerThumbnailUrl: String?
    var trailerVideoUrl: String?
    var isTrailerProcessed: Bool
    
    struct StripeAccount : Equatable, Codable {
        let productId: String?
        let currencyCode: CurrencyCode?
        let price: Int?
        let balance: Int?
        let totalVolume: Int?
    }
    
    let stripeAccount: StripeAccount
}
