//
//  MediaPickerAdapter.swift
//  Broadcast
//
//  Created by Piotr Suwara on 2/12/20.
//

import UIKit
import AVFoundation
import Photos

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
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.denied {
            showDeniedAlert(title: "Unable to access the photo library",
                            message: "To enable access, go to Settings > Privacy > Photos and turn on Photos access for this app.")
        } else if authStatus == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization { authStatus in
                DispatchQueue.main.async {
                    if #available(iOS 14, *) {
                        /// Limited only available in iOS 14
                        if authStatus == .authorized || authStatus == .limited {
                            self.showImagePickerForLibrary(forTag: tag)
                        }
                    } else {
                        if authStatus == .authorized {
                            self.showImagePickerForLibrary(forTag: tag)
                        }
                    }
                }
            }
        } else {
            showImagePickerForLibrary(forTag: tag)
        }
    }
    
    func showImagePickerForLibrary(forTag tag: PickerTag = 0) {
        let selectedPicker = picker(forTag: tag)
        selectedPicker.sourceType = .photoLibrary
        selectedPicker.mediaTypes = supportedAlbumModes(forTag: tag)
        selectedPicker.modalPresentationStyle = UIModalPresentationStyle.popover
        present(selectedPicker, animated: true, completion: nil)
    }
    
    /// Function to create an image picker controller that allows media selection
    func mediaFromCamera(forTag tag: PickerTag = 0) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.denied {
            showDeniedAlert(title: "Unable to access the Camera",
                            message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        } else if (authStatus == AVAuthorizationStatus.notDetermined) {
            // The user has not yet been presented with the option to grant access to the camera hardware.
            // Ask for permission.
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.showImagePickerForCamera(forTag: tag)
                    }
                }
            })

        } else {
            // Allowed access to camera, go ahead and present the UIImagePickerController.
            showImagePickerForCamera(forTag: tag)
        }
    }
    
    private func showImagePickerForCamera(forTag tag: PickerTag = 0) {
        let selectedPicker = picker(forTag: tag)
        selectedPicker.sourceType = .camera
        selectedPicker.mediaTypes = supportedCameraModes(forTag: tag)
        selectedPicker.modalPresentationStyle = .fullScreen
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
    
    // MARK: Internal functions
    
    private func showDeniedAlert(title: String, message: String) {
        // Denied access to camera, alert the user.
        // The user has previously denied access. Remind the user that we need camera access to be useful.
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)

        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)

        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            // Take the user to Settings app to possibly change permission.
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    // Finished opening URL
                })
            }
        })

        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }
}

