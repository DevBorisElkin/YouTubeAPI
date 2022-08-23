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
    
    static let ytQuotaExceededTitle = "YouTube API quota exceeded"
    static let ytQuotaExceededMessage = "YouTube limits it's API usage by a quota, gives each 'user' 10000 so called 'points' daily. Search request costs 100 points, so, daily quota is enough for 100 search requests. Unfortunately, quota for API key, generated for this app exceeded. It will 'regenerate' eventually (quota points regenerate slowly each minute). Try again later."
}
