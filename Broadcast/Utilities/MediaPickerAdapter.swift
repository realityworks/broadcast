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
}

// MARK: Image Picker in a UIViewController

/// Allow the UIViewControllerto handle delegate calls from the ImagePicker
extension UIViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {}

/// Implementation of the media picker when the current object is a view controller
extension MediaPickerAdapter where Self: UIViewController {
    
    // MARK: MediaPickerAdapter protocol
    
    /// Function to create an image picker controller that allows media selection
    func mediaFromLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    /// Function to create an image picker controller that allows media selection
    func mediaFromCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(
      _ picker: UIImagePickerController
    ) {
      dismiss(animated: true, completion: nil)
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
            title: "Take Photo",
            style: .default,
            handler: nil)
        alert.addAction(actPhoto)

        let actLibrary = UIAlertAction(
            title: "Choose From Library",
            style: .default,
            handler: )
        alert.addAction(actLibrary)

        present(alert, animated: true, completion: nil)
    }
}

