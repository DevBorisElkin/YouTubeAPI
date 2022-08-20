//
//  YouTubeCommentCellLayoutCalculator.swift
//  YouTubeAPI
//
//  Created by test on 20.08.2022.
//

import Foundation
import UIKit

class YouTubeCommentCellLayoutCalculator {
    static func calculateCommentCellSizes(topDescriptionText: String, commentText: String, isFullSizedPost: Bool) -> CommentViewModel.CommentCellSizes {
        
        // MARK: Calculate commentAuthorImageRect
        let commentAuthorImageRect = CGRect(x: CommentCellConstants.commentAuthorIconInsets.left,
                                            y: CommentCellConstants.commentAuthorIconInsets.top,
                                            width: CommentCellConstants.commentAuthorIconSize,
                                            height: CommentCellConstants.commentAuthorIconSize)
        
        // MARK: Calculate topText frame
        var topTextRect = CGRect(
            origin: CGPoint(
                x: commentAuthorImageRect.maxX + CommentCellConstants.commentTopLineInsets.left,
                y: CommentCellConstants.commentTopLineInsets.top),
            size: CGSize.zero)
        
        let topTextWidth: CGFloat = AppConstants.screenWidth - CommentCellConstants.commentTopLineInsets.left - CommentCellConstants.commentTopLineInsets.right - CommentCellConstants.commentAuthorIconSize - CommentCellConstants.commentAuthorIconInsets.left
        
        if !topDescriptionText.isEmpty {
            let height = topDescriptionText.height(width: topTextWidth, font: CommentCellConstants.commentTopLineFont)
            topTextRect.size = CGSize(width: topTextWidth, height: height)
        }
        
        // MARK: Calculate commentText frame
        // 2 frames, one is full sized, the other is capped sized
        var commentTextSizeRect = CGRect(
            origin: CGPoint(
                x: commentAuthorImageRect.maxX + CommentCellConstants.commentTextInsets.left,
                y: topTextRect.maxY + CommentCellConstants.commentTextInsets.top),
            size: CGSize.zero)
        
        let commentTextWidth: CGFloat = AppConstants.screenWidth - CommentCellConstants.commentTextInsets.left - CommentCellConstants.commentTextInsets.right - CommentCellConstants.commentAuthorIconSize - CommentCellConstants.commentAuthorIconInsets.left
        
        var showMoreTextButton = false
        
        if !commentText.isEmpty {
            var height = commentText.height(width: commentTextWidth, font: CommentCellConstants.commentTextFont)
            
            // check limit height for name label
            let limitHeight = CommentCellConstants.commentTextFont.lineHeight * CommentCellConstants.commentTextMaxLines
            
            if height > (limitHeight + 1) && !isFullSizedPost {
                height = limitHeight
                showMoreTextButton = true
            }
            commentTextSizeRect.size = CGSize(width: commentTextWidth, height: height)
        }
        
        // MARK: expandCommentText frame
        let expandCommentTextButtonFrame = showMoreTextButton == false ? CGRect.zero : CGRect(
            x: CommentCellConstants.expandTextButtonInsets.left + CommentCellConstants.commentAuthorIconSize + CommentCellConstants.expandTextButtonInsets.left,
            y: commentTextSizeRect.maxY + CommentCellConstants.expandTextButtonInsets.top,
            width: AppConstants.screenWidth - CommentCellConstants.expandTextButtonInsets.left - CommentCellConstants.expandTextButtonInsets.right,
            height: CommentCellConstants.expandTextButtonHeight)
        
        // MARK: repliesCount frame
        let repliesCountFrame = CGRect.zero
        
        // MARK: commentCell height
        
        let selectedCellHeight: CGFloat = showMoreTextButton ? expandCommentTextButtonFrame.maxY + CommentCellConstants.commentCellBottomInset : commentTextSizeRect.maxY + CommentCellConstants.commentCellBottomInset
        
        let sizes = CommentViewModel.CommentCellSizes(commentAuthorIconFrame: commentAuthorImageRect,
                                                      topTextFrame: topTextRect,
                                                      commentTextFrame: commentTextSizeRect,
                                                      expandCommentTextButtonFrame: expandCommentTextButtonFrame,
                                                      repliesCountLabelFrame: repliesCountFrame,
                                                      tableViewCellHeight: selectedCellHeight)
        
        return sizes
    }
}
