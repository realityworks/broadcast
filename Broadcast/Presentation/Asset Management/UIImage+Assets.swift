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
    static let iconPlusSquare = UIImage(systemName: "plus.app")
    static let iconProfile = UIImage(named: "icon-profile")
    static let iconRadio = UIImage(named: "icon-radio")
    static let iconReload = UIImage(named: "icon-reload")
    static let iconShare = UIImage(named: "icon-share")
    static let iconSlash = UIImage(named: "icon-slash")
    static let logoBoomdayBroadcaster = UIImage(named: "logo-boomday-broadcaster")
    static let iconChevronLeft = UIImage(named: "icon-chevron-left")
    static let iconChevronRight = UIImage(named: "icon-chevron-right")
    static let iconHelpCricle = UIImage(named: "icon-help-circle")
    
    static let iconAlertCirc = UIImage(named:"icon-alert-circ")
    static let iconArrowRight = UIImage(named:"icon-arrow-right")
    static let iconHeart = UIImage(named:"icon-heart")
    static let iconStar = UIImage(named:"icon-star")
    static let iconArrowLeft = UIImage(named:"icon-arrow-left")
    static let iconCheckSimple = UIImage(named:"icon-check-simple")
    static let iconInfo = UIImage(named:"icon-info")
    static let iconSmile = UIImage(named:"icon-smile")
    static let iconWifi = UIImage(named:"icon-wifi")
    static let iconPortrait = UIImage(named:"icon-portrait")
    static let iconSimpleSun = UIImage(named: "icon-simple-sun")
    static let iconThumbUp = UIImage(named: "icon-thumb-u")
    
    static var profileImage: UIImage? {
        return UIImage(contentsOfKey: Self.profileImageKey) ?? UIImage(color: .primaryRed)
    }
}
