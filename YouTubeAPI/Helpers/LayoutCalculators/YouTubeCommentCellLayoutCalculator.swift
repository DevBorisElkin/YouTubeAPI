//
//  YouTubeCommentCellLayoutCalculator.swift
//  YouTubeAPI
//
//  Created by test on 20.08.2022.
//

import Foundation
import UIKit

class YouTubeCommentCellLayoutCalculator {
    static func calculateCommentCellSizes(topDescriptionText: String, commentText: String, showFullCommentText: Bool) -> CommentViewModel.CommentCellSizes {
        
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
        var commentTextFullSizeRect = CGRect(
            origin: CGPoint(
                x: commentAuthorImageRect.maxX + CommentCellConstants.commentTextInsets.left,
                y: topTextRect.maxY + CommentCellConstants.commentTextInsets.top),
            size: CGSize.zero)
        var commentTextCappedSizeRect = commentTextFullSizeRect
        var selectedCommentTextSizeRect = CGRect.zero
        
        let commentTextWidth: CGFloat = AppConstants.screenWidth - CommentCellConstants.commentTextInsets.left - CommentCellConstants.commentTextInsets.right - CommentCellConstants.commentAuthorIconSize - CommentCellConstants.commentAuthorIconInsets.left
        
        if !commentText.isEmpty {
            let height = commentText.height(width: commentTextWidth, font: CommentCellConstants.commentTextFont)
            var cappedHeight = height
            
            // check limit height for name label
            let limitHeight = CommentCellConstants.commentTextFont.lineHeight * CommentCellConstants.commentTextMaxLines
            
            if height > limitHeight {
                cappedHeight = CommentCellConstants.commentTextFont.lineHeight * CommentCellConstants.commentTextMaxLines
            }
            commentTextFullSizeRect.size = CGSize(width: commentTextWidth, height: height)
            commentTextCappedSizeRect.size = CGSize(width: commentTextWidth, height: cappedHeight)
            
            selectedCommentTextSizeRect = showFullCommentText ? commentTextFullSizeRect : commentTextCappedSizeRect
        }
        
        // MARK: expandCommentText frame
        let expandCommentTextButtonFrame = showFullCommentText ? CGRect(
            x: CommentCellConstants.expandTextButtonInsets.left,
            y: selectedCommentTextSizeRect.maxY + CommentCellConstants.expandTextButtonInsets.top,
            width: AppConstants.screenWidth - CommentCellConstants.expandTextButtonInsets.left - CommentCellConstants.expandTextButtonInsets.right,
            height: CommentCellConstants.expandTextButtonHeight) : CGRect.zero
        
        // MARK: repliesCount frame
        let repliesCountFrame = CGRect.zero
        
        // MARK: commentCell height
        let commentCellCappedHeight: CGFloat = expandCommentTextButtonFrame.maxY + CommentCellConstants.commentCellBottomInset
        let commentCellFullHeight: CGFloat = commentTextFullSizeRect.maxY + CommentCellConstants.commentCellBottomInset
        
        let selectedCellHeight: CGFloat = showFullCommentText ? commentCellFullHeight : commentCellCappedHeight
        
        let sizes = CommentViewModel.CommentCellSizes(commentAuthorIconFrame: commentAuthorImageRect,
                                                      topTextFrame: topTextRect,
                                                      commentTextFrame: selectedCommentTextSizeRect,
                                                      expandCommentTextButtonFrame: expandCommentTextButtonFrame,
                                                      repliesCountLabelFrame: repliesCountFrame,
                                                      tableViewCellHeight: selectedCellHeight)
        
        return sizes
    }
}
