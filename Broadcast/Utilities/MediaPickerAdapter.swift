//
//  MediaPickerAdapter.swift
//  Broadcast
//
//  Created by Piotr Suwara on 2/12/20.
//

import UIKit

/// Protocol that defines the functionality related to selecting
/// media from the phone
protocol MediaPickerAdapter: NSObject {
    func selectMediaFromLibrary()
}

/// Implementation of the media picker when the current object is a view controller
extension MediaPickerAdapter where Self: UIViewController {
    
    /// Function to create an image picker controller that allows media selection
    func selectMediaFromLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
}


