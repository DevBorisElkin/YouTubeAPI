//
//  VideoPlayerConstants.swift
//  YouTubeAPI
//
//  Created by test on 18.08.2022.
//

import UIKit
import Foundation

class VideoPlayerConstants {
    // MARK: Fonts
    static let videoNameFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let videoNameFontMaxLines: CGFloat = 2
    static let videoDetailsFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let videoDetailsFontMaxLines: CGFloat = 2
    
    // MARK: Colors
    static let videoNameFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    static let videoDetailsFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    
    // MARK: Insets
    static let videoNameInsets = UIEdgeInsets(top: 12, left: 10, bottom: 5, right: 10)
    static let videoDetailsInsets = UIEdgeInsets(top: 6, left: 10, bottom: 8, right: 10)
    
    // MARK: Separators
    static let separatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    static let separatorHeight: CGFloat = 0.7
    
    // MARK: Channel Info Constants
    static let channelInfoPanelInsets = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
    
    static let channelIconSize: CGFloat = 45
    static let channelIconInsets = UIEdgeInsets(top: 8, left: 9, bottom: 8, right: 9)
    
    static let channelInfoStackViewInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
    static let channelNameFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let channelNameFontMaxLines: CGFloat = 1
    
    static let subscribersCountFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let subscribersCountMaxLines: CGFloat = 1
    
    static let channelNameFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    static let subscribersCountFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    
    // MARK: Comments Info constants
    static let commentsViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    static let commentsViewHeight: CGFloat = 50
    
    static let commentsLabelInsets = UIEdgeInsets(top: 7, left: 10, bottom: 0, right: 0)
    static let commentsLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let commentsLabelFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    
    static let commentsCountLabelInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    static let commentsCountLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let commentsCountLabelFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    
    static let expandCommentsButtonInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    static let expandCommentsButtonSize = CGSize(width: 180, height: 20)
    static let expandCommentsButtonFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let expandCommentsButtonFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    
    static let expandCommentsInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
}
