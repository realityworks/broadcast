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

        /// This may be added back later
        case totalBalance(text: String)
        case lifetimeTotalVolume(text: String)
    }
    
    let nameObservable: Observable<String>
    let identifierObservable: Observable<String>
    let pricingObservable: Observable<String>
    let totalBalanceObservable: Observable<String>
    let lifetimeTotalVolumeObservable: Observable<String>
    
    init(dependencies: Dependencies = .standard) {
        let stripeAccountObservable = dependencies.profileObservable
            .compactMap { $0?.stripeAccount }
        
        self.nameObservable = stripeAccountObservable.map { $0.accountId ?? LocalizedString.nonExistant.localized }
        self.identifierObservable = stripeAccountObservable.map { $0.productId ?? LocalizedString.nonExistant.localized }
        
        self.pricingObservable = stripeAccountObservable.map {
            guard let currencyCode = $0.currencyCode else { return LocalizedString.nonExistant.localized }
            return $0.price?.asCurrencyString(withCurrencyCode: currencyCode) ?? LocalizedString.nonExistant.localized
        }
        
        self.totalBalanceObservable = stripeAccountObservable.map {
            guard let currencyCode = $0.currencyCode else { return LocalizedString.nonExistant.localized }
            return $0.balance?.asCurrencyString(withCurrencyCode: currencyCode) ?? LocalizedString.nonExistant.localized
        }
        
        self.lifetimeTotalVolumeObservable = stripeAccountObservable.map {
            guard let currencyCode = $0.currencyCode else { return LocalizedString.nonExistant.localized }
            return $0.totalVolume?.asCurrencyString(withCurrencyCode: currencyCode) ?? LocalizedString.nonExistant.localized
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

