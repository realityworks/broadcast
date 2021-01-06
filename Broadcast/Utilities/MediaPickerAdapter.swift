//
//  MediaPickerAdapter.swift
//  Broadcast
//
//  Created by Piotr Suwara on 2/12/20.
//

import UIKit

typealias PickerTag = Int

/// Protocol that defines the functionality related to selecting
/// media from the phone
protocol MediaPickerAdapter: NSObject {
    func supportedAlbumModes(forTag tag: PickerTag) -> [String]
    func supportedCameraModes(forTag tag: PickerTag) -> [String]
    func mediaFromLibrary(forTag tag: PickerTag)
    func mediaFromCamera(forTag tag: PickerTag)
    func showMediaOptionsMenu(forTag tag: PickerTag)
    func selected(imageUrl: URL)
    func selected(videoUrl: URL)
    func picker(forTag tag: PickerTag) -> UIImagePickerController
}

extension MediaPickerAdapter {
    func supportedAlbumModes(forTag tag: PickerTag) -> [String] {
        return UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
    }
    
    func supportedCameraModes(forTag tag: PickerTag) -> [String] {
        return UIImagePickerController.availableMediaTypes(for: .camera) ?? []
    }
}

// MARK: Image Picker in a UIViewController

/// Implementation of the media picker when the current object is a view controller
extension MediaPickerAdapter where Self: UIViewController {
    
    // MARK: MediaPickerAdapter protocol
    
    /// Function to create an image picker controller that allows media selection
    func mediaFromLibrary(forTag tag: PickerTag = 0) {
        let selectedPicker = picker(forTag: tag)
        selectedPicker.sourceType = .savedPhotosAlbum
        selectedPicker.mediaTypes = supportedAlbumModes(forTag: tag)
        present(selectedPicker, animated: true, completion: nil)
    }
    
    /// Function to create an image picker controller that allows media selection
    func mediaFromCamera(forTag tag: PickerTag = 0) {
        let selectedPicker = picker(forTag: tag)
        selectedPicker.sourceType = .camera
        selectedPicker.mediaTypes = supportedCameraModes(forTag: tag)
        present(selectedPicker, animated: true, completion: nil)
    }
    
    func showMediaOptionsMenu(forTag tag: PickerTag = 0) {
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
                self?.mediaFromCamera(forTag: tag)
            })
        alert.addAction(actPhoto)

        let actLibrary = UIAlertAction(
            title: "Library",
            style: .default,
            handler: { [weak self] action in
                self?.mediaFromLibrary(forTag: tag)
            })
        alert.addAction(actLibrary)

        present(alert, animated: true, completion: nil)
    }
}

