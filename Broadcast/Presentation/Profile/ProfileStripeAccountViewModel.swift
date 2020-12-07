//
//  ProfileSubscriptionViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import Foundation

class ProfileStripeAccountViewModel : ViewModel {
    
    enum Row {
        case name(text: String)
        case identifier(text: String)
        case pricing(text: String)
        case payments(text: String)
        case payouts(text: String)
        case totalBalance(text: String)
        case lifetimeTotalVolume(text: String)
    }
    
    let nameObservable: Observable<String>
    let identifierObservable: Observable<String>
    let pricingObservable: Observable<String>
    let payments: Observable<String>
    let payouts: Observable<String>
    let totalBalance: Observable<String>
    let lifetimeTotalVolume: Observable<String>
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
        
        currencyCode: CurrencyCode, amount: Float
    }
    
}

/// NewPostViewModel dependencies component
extension ProfileStripeAccountViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
    }
}

