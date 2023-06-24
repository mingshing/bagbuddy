//
//  Constants.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import Foundation
import UIKit

struct LayoutConstants {
    static let miniBarHeight: CGFloat = 76.0
    static let navigationBarHeight: CGFloat = 56.0
    static let actionButtonHeight: CGFloat = 48.0
    static let inputFieldHeight: CGFloat = 44.0
    static let smallIconSize: CGFloat = 16.0
    static let actionIconWidth: CGFloat = 48.0
    static let actionIconHeight: CGFloat = 44.0
    //margin
    static let pageHorizontalMargin: CGFloat = 20.0
    
    //input content inset
    static let horizontalMargin: CGFloat = 16.0
    static let verticalMargin: CGFloat = 10.0
}

struct DeviceConstants {
    static var width: CGFloat {
        get {
            let screenSize: CGRect = UIScreen.main.bounds
            return screenSize.width
        }
    }
    static var height: CGFloat {
        get {
            let screenSize: CGRect = UIScreen.main.bounds
            return screenSize.height
        }
    }
}

struct LocalFileName {
    static let cityList: String = "cityList"
    static let suggestItemList: String = "suggestedItemList"
    static let essentialItemList: String = "essential"
    static let interNationalTripItemList: String = "national"
}

struct HostAppContants {
    static let chatGPTUrl = "https://test"
}
