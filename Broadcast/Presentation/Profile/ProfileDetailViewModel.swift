//
//  ProfileDetailViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ProfileDetailViewModel : ViewModel {
    
    enum Row {
        case profileInfo(profileImage: UIImage, subscribers: Int)
        case displayName(text: String)
        case biography(text: String)
        case trailerVideo(trailerUrl: URL?, uploadProgress: UploadProgress)        
    }
        
    let schedulers: Schedulers
    let profileUseCase: ProfileUseCase

    let subscriberCount: Observable<Int>
    let profileImage: Observable<UIImage>
    let trailerVideoUrl: Observable<URL?>
    
    let displayNameObservable: Observable<String?>
    let displayNameSubject = BehaviorRelay<String?>(value: nil)
    let biographyObservable: Observable<String?>
    let biographySubject = BehaviorRelay<String?>(value: nil)
    
    let trailerUploadProgress: Observable<UploadProgress>
    
    init(dependencies: Dependencies = .standard) {
        
        self.schedulers = dependencies.schedulers
        self.profileUseCase = dependencies.profileUseCase
        
        let profileObservable = dependencies.profileObservable.compactMap { $0 }
        displayNameObservable = profileObservable.map { $0.displayName }
        biographyObservable = profileObservable.map { $0.biography ?? String.empty }
        
        self.subscriberCount = profileObservable.map { $0.subscriberCount }
        self.profileImage = dependencies.profileImage.compactMap { $0 ?? UIImage.profileImage }
        
        self.trailerVideoUrl = profileObservable.map { URL(string: $0.trailerVideoUrl) }
        
        self.trailerUploadProgress = dependencies.trailerUploadProgress.compactMap { $0 }
        
        super.init(stateController: dependencies.stateController)
        
        displayNameObservable
            .subscribe(onNext: { self.displayNameSubject.accept($0) })
            .disposed(by: disposeBag)
        
        biographyObservable
            .subscribe(onNext: { self.biographySubject.accept($0) })
            .disposed(by: disposeBag)
    }
}

/// NewPostViewModel dependencies component
extension ProfileDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let schedulers: Schedulers
        let profileUseCase: ProfileUseCase
        let profileImage: Observable<UIImage?>
        let profileObservable: Observable<Profile?>
        let trailerUploadProgress: Observable<UploadProgress?>
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            schedulers: Schedulers.standard,
            profileUseCase: Domain.standard.useCases.profileUseCase,
            profileImage: Domain.standard.stateController.stateObservable(of: \.profileImage),
            profileObservable: Domain.standard.stateController.stateObservable(of: \.profile),
            trailerUploadProgress: Domain.standard.stateController.stateObservable(of: \.currentTrailerUploadProgress))
    }
}

// MARK: - Usecase functions

extension ProfileDetailViewModel {
    func updateProfile() {
        guard let displayName = displayNameSubject.value,
              let biography = biographySubject.value else { return }
        
        profileUseCase.updateProfile(displayName: displayName,
                                     biography: biography)
            .subscribe(onCompleted: {
                // Mark as update complete (loader)
                print("Profile update returned success!")
            }, onError: { [unowned self] error in
                self.stateController.sendError(error)
                Logger.log(level: .warning, topic: .authentication, message: "Unable to update the broadcaster profile: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func profileImageSelected(withUrl url: URL) {
        if let image = UIImage(contentsOfFile: url.path) {
            profileUseCase.updateLocalProfile(image: image)
        }
        
        profileUseCase.updateProfile(image: url)
            .subscribe { _ in
            } onError: { error in
                self.stateController.sendError(error)
            } onCompleted: {
            }
            .disposed(by: disposeBag)

    }
    
    func trailerSelected(withUrl url: URL) {
        profileUseCase.uploadTrailer(withUrl: url)
    }
}
