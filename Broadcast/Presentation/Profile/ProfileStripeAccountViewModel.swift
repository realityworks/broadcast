//
//  ProfileSubscriptionViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import Foundation
import RxSwift
import RxCocoa

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
    let paymentsObservable: Observable<String>
    let payoutsObservable: Observable<String>
    let totalBalanceObservable: Observable<String>
    let lifetimeTotalVolumeObservable: Observable<String>
    
    init(dependencies: Dependencies = .standard) {
        let stripeAccountObservable = dependencies.profileObservable
            .compactMap { $0?.stripeAccount }
        
        self.nameObservable = stripeAccountObservable.map { $0.name }
        self.identifierObservable = stripeAccountObservable.map { $0.id }
        self.paymentsObservable = stripeAccountObservable.map { $0.paymentsDisabled ? "Disabled" : "Enabled" }
        
        self.pricingObservable = stripeAccountObservable.map {
            $0.pricing.asCurrencyString(withCurrencyCode: $0.currencyCode)
        }
        
        self.payoutsObservable = stripeAccountObservable.map { $0.payoutsDisabled ? LocalizedString.disabled.localized : LocalizedString.enabled.localized
        }
        
        self.totalBalanceObservable = stripeAccountObservable.map {
            $0.balance.asCurrencyString(withCurrencyCode: $0.currencyCode)
        }
        
        self.lifetimeTotalVolumeObservable = stripeAccountObservable.map {
            $0.totalVolume.asCurrencyString(withCurrencyCode: $0.currencyCode)
        }

        super.init(stateController: dependencies.stateController)
    }
    
}

/// NewPostViewModel dependencies component
extension ProfileStripeAccountViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let profileObservable: Observable<Profile?>
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            profileObservable: Domain.standard.stateController.stateObservable(of: \.profile))
    }
}

