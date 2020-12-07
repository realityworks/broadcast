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
        case profileInfo(thumbnail: URL?, subscribers: Int)
        case displayName(text: String)
        case biography(text: String)
        case trailerVideo(trailer: URL?)
        
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

    let displayName: Observable<String>
    let biography: Observable<String>
    let subscribers: Observable<Int>
    let thumbnail: Observable<URL?>
    let trailer: Observable<URL?>
    
    let displayNameSubject = BehaviorRelay<String?>(value: nil)
    let biographySubject = BehaviorRelay<String?>(value: nil)
    
    init(dependencies: Dependencies = .standard) {
        
        self.schedulers = dependencies.schedulers
        self.profileUseCase = dependencies.profileUseCase
        
        let profileObservable = dependencies.profileObservable.compactMap { $0 }
        
        self.displayName = profileObservable.map { $0.displayName }
        self.biography = profileObservable.map { $0.biography }
        self.subscribers = profileObservable.map { $0.subscribers }
        self.thumbnail = profileObservable.map { URL(string: $0.thumbnailUrl) }
        self.trailer = profileObservable.map { URL(string: $0.trailerUrl) }
        
        super.init(stateController: dependencies.stateController)
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
