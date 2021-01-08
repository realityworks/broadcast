//
//  State.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import UIKit

/// Base class used to describe the local state of all data on the application.
/// The state can be updated and propagated throughout.
struct State : Equatable {
    var authenticationState: AuthenticationState = .loggedOut
    var appState: AppState = .inactive
    var connectionState: ConnectionState = .connected
    var myPosts: [Post] = []
    
    var profile: Profile?
    var profileImage: UIImage?
    
    var selectedPostId: PostID?
    
    
    var currentMediaUploadProgress: UploadProgress?
    var currentTrailerUploadProgress: UploadProgress?
}
