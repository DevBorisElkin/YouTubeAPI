//
//  CommentCellConstants.swift
//  YouTubeAPI
//
//  Created by test on 20.08.2022.
//

import Foundation
import UIKit

class CommentCellConstants {
    // MARK: Fonts
    static let commentTopLineFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    static let commentTopLineFontMaxLines: CGFloat = 1 // todo not used
    static let commentTextFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let commentTextMaxLines: CGFloat = 3
    
    // MARK: Colors
    static let commentTopLineFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    static let commentTextFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    
    // MARK: Insets and Sizes
    static let commentAuthorIconSize: CGFloat = 45
    static let commentAuthorIconInsets = UIEdgeInsets(top: 7, left: 3, bottom: 0, right: 0)
    
    static let commentTopLineInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    static let commentTextInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    static let expandTextButtonFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let expandTextButtonHeight: CGFloat = 20
    static let expandTextButtonInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    static let commentCellBottomInset: CGFloat = 10
    
    // MARK: Inset to load more comments
    static let commentInsetToLoadMoreComments: CGFloat = 20
}
