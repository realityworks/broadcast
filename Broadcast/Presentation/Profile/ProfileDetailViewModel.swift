//
//  ProfileDetailViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileDetailViewModel : ViewModel {
    
    enum Row {
        case profileInfo(profileImageUrl: URL?, subscribers: Int)
        case displayName(text: String)
        case biography(text: String)
        case trailerVideo(trailerUrl: URL?)
        
        var row: Int {
            switch self {
            case .profileInfo: return 0
            case .displayName: return 1
            case .biography: return 2
            case .trailerVideo: return 3
            }
        }
    }
        
    let schedulers: Schedulers
    let profileUseCase: ProfileUseCase

    let subscriberCount: Observable<Int>
    let profileImageUrl: Observable<URL?>
    let trailerVideoUrl: Observable<URL?>
    
    let displayNameSubject = BehaviorRelay<String?>(value: nil)
    let biographySubject = BehaviorRelay<String?>(value: nil)
    
    init(dependencies: Dependencies = .standard) {
        
        self.schedulers = dependencies.schedulers
        self.profileUseCase = dependencies.profileUseCase
        
        let profileObservable = dependencies.profileObservable.compactMap { $0 }
        
        self.subscriberCount = profileObservable.map { $0.subscriberCount }
        self.profileImageUrl = profileObservable.map { URL(string: $0.profileImageUrl) }
        self.trailerVideoUrl = profileObservable.map { URL(string: $0.trailerVideoUrl) }
        
        super.init(stateController: dependencies.stateController)
        
        // Biography subject should be updated by the stored biography info
        _ = profileObservable.map { $0.biography ?? String.empty }
            .subscribe(onNext: {
                self.biographySubject.accept($0)
            })
            .disposed(by: disposeBag)
        
        _ = profileObservable.map { $0.displayName }
            .subscribe(onNext: {
                print ("Update DisplayName : \($0)")
                return self.displayNameSubject.accept($0)
            })
            .disposed(by: disposeBag)
    }
}

/// NewPostViewModel dependencies component
extension ProfileDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let schedulers: Schedulers
        let profileUseCase: ProfileUseCase
        let profileObservable: Observable<Profile?>
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            schedulers: Schedulers.standard,
            profileUseCase: Domain.standard.useCases.profileUseCase,
            profileObservable: Domain.standard.stateController.stateObservable(of: \.profile))
    }
}

// MARK: - Usecase functions

extension ProfileDetailViewModel {
    func updateProfile() {
        guard let displayName = displayNameSubject.value,
              let biography = biographySubject.value else { return }
        
        profileUseCase.updateProfile(displayName: displayName,
                                     biography: biography)
    }
    
    func trailerSelected(withUrl url: URL) {
        profileUseCase.uploadTrailer(withUrl: url)
    }
}
