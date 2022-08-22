//
//  AppConstants.swift
//  YouTubeAPI
//
//  Created by test on 11.08.2022.
//

import Foundation
import UIKit

class AppConstants {
    static var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    static var safeAreaPadding: UIEdgeInsets = UIEdgeInsets.zero
    
    static func initializePaddings(window: UIWindow){
        safeAreaPadding = window.safeAreaInsets
    }
    
    // for https://yt3.ggpht.com since it's blocked in Russia
    // https://yt3.ggpht.com works, but most images won't load anyway
    /// if 'true' app will try to load static content (channel images) from http rather than https, however, most images with hppt won't load
    static var preferHttpForStaticContent: Bool = false
    
    // to see loading spinners and etc.
    static let commentRequestArtificialDelay: Double = 0.6
    
    static let expandCustomButtonsClickArea = CGPoint(x: 10, y: 10)
}
