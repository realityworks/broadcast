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
    func mediaFromLibrary()
    func mediaFromCamera()
    func showMediaOptionsMenu()
    func selected(imageUrl: URL)
    func selected(videoUrl: URL)
    var picker: UIImagePickerController { get }
}

// MARK: Image Picker in a UIViewController

/// Implementation of the media picker when the current object is a view controller
extension MediaPickerAdapter where Self: UIViewController {
    
    // MARK: MediaPickerAdapter protocol
    
    /// Function to create an image picker controller that allows media selection
    func mediaFromLibrary() {
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        present(picker, animated: true, completion: nil)
    }
    
    /// Function to create an image picker controller that allows media selection
    func mediaFromCamera() {
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        present(picker, animated: true, completion: nil)
    }
    
    func showMediaOptionsMenu() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)

        let actCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        alert.addAction(actCancel)

        let actPhoto = UIAlertAction(
            title: "Camera",
            style: .default,
            handler: { [weak self] action in
                self?.mediaFromCamera()
            })
        alert.addAction(actPhoto)

        let actLibrary = UIAlertAction(
            title: "Library",
            style: .default,
            handler: { [weak self] action in
                self?.mediaFromLibrary()
            })
        alert.addAction(actLibrary)

        present(alert, animated: true, completion: nil)
    }
}

