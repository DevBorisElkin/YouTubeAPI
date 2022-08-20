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
    static let commentTopLineFontMaxLines: CGFloat = 1
    static let commentTextFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let commentTextMaxLines: CGFloat = 0
    
    // MARK: Colors
    static let commentTopLineFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    static let commentTextFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    
    // MARK: Insets
    static let commentAuthorIconSize: CGFloat = 45
    static let commentAuthorIconInsets = UIEdgeInsets(top: 7, left: 3, bottom: 0, right: 0)
    
    static let commentTopLineInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    static let commentTextInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
}
