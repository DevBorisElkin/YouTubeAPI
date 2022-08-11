//
//  VideoCellConstants.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation
import UIKit

class VideoCellConstants {
    // MARK: Fonts
    static let videoNameFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let videoNameFontMaxLines: CGFloat = 2
    static let videoDetailsFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let videoDetailsFontMaxLines: CGFloat = 1
    
    // MARK: Colors
    static let videoNameFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    static let videoDetailsFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    
    static let cardViewOffset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    static let videoImageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    static let channelIconSize: CGFloat = 45
    static let channelIconInsets = UIEdgeInsets(top: 8, left: 8, bottom: 5, right: 8)
    
    static let videoNameInsets = UIEdgeInsets(top: 8, left: 8, bottom: 5, right: 8)
    static let videoDetailsInsets = UIEdgeInsets(top: 6, left: 8, bottom: 5, right: 8)
}
