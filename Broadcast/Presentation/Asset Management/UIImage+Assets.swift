//
//  UIImage+Assets.swift
//  Broadcast
//
//  Created by Piotr Suwara on 25/11/20.
//

import UIKit

extension UIImage {
    static let profileImageKey = "profile-image"
    static let appIcon = UIImage(named: "AppIcon")
    static let boomdayLogo = UIImage(named: "logo-boomday")
    static let broadcasterLogo = UIImage(named: "logo-broadcaster")
    static let iconBookMarkOff = UIImage(named: "icon-bookmark-off")
    static let iconCreditCard = UIImage(named: "icon-credit-card")
    static let iconCustomBrightness = UIImage(named: "icon-custom-brightness")
    static let iconCustomPortraitMode = UIImage(named: "icon-custom-portrait-mode")
    static let iconCustomTimer = UIImage(named: "icon-custom-timer")
    static let iconCustomCamera = UIImage(named: "icon-custom-camera")
    static let iconDocument = UIImage(named: "icon-file-text")
    static let iconEye = UIImage(named: "icon-eye")
    static let iconHelp = UIImage(named: "icon-help-circle")
    static let iconLock = UIImage(named: "icon-lock")
    static let iconMessage = UIImage(named: "icon-message")
    static let iconPlusCircle = UIImage(named: "icon-plus-circle")
    static let iconProfile = UIImage(named: "icon-profile")
    static let iconRadio = UIImage(named: "icon-radio")
    static let iconShare = UIImage(named: "icon-share")
    static let logoBoomdayBroadcaster = UIImage(named: "logo-boomday-broadcaster")
    static let iconChevronLeft = UIImage(named: "icon-chevron-right")
    static let iconHelpCricle = UIImage(named: "icon-help-circle")
    
    static var profileImage: UIImage? {
        return UIImage(contentsOfKey: Self.profileImageKey) ?? UIImage(color: .primaryRed)
    }
}
