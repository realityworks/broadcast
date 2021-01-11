//
//  UploadProgress+TextDescription.swift
//  Broadcast
//
//  Created by Piotr Suwara on 11/1/21.
//

import Foundation

extension UploadProgress {
    static var initialProgressText: String = "\(LocalizedString.uploading.localized) - 0%"
    
    var progressText: String {
        if completed {
            return LocalizedString.uploadCompleted.localized
        } else if failed {
            return "\(LocalizedString.uploadFailed.localized) \(errorDescription ?? "")"
        }
        
        return String(format: "\(LocalizedString.uploading.localized)%2.0f%%", totalProgress * 100)
    }
}
