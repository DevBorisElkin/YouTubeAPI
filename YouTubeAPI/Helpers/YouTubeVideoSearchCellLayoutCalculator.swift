//
//  YouTubeVideoSearchCellLayoutCalculator.swift
//  YouTubeAPI
//
//  Created by test on 12.08.2022.
//

import Foundation
import UIKit

class YouTubeVideoSearchCellLayoutCalculator {
    static func calculateYTCellSizes(imageWidth: CGFloat, imageHeight: CGFloat, videoNameText: String, detailsString: String) -> VideoViewModel.Sizes {
        
        var aspectRatio: CGFloat = imageHeight / imageWidth
        
        // MARK: Calculate image frame -> width, height, x, y pos.
        let imageWidth = AppConstants.screenWidth - VideoCellConstants.cardViewOffset.left - VideoCellConstants.cardViewOffset.right - VideoCellConstants.videoImageInsets.left - VideoCellConstants.videoImageInsets.right
        let imageHeight = imageWidth * aspectRatio
        let imageYPos: CGFloat = VideoCellConstants.videoImageInsets.top
        let imageFrame = CGRect(x: VideoCellConstants.videoImageInsets.left, y: imageYPos, width: imageWidth, height: imageHeight)
        
        // MARK: Calculate videoName frame
        var videoNameRect = CGRect(
            origin: CGPoint(
                x: VideoCellConstants.channelIconInsets.left + VideoCellConstants.channelIconSize + VideoCellConstants.videoNameInsets.left,
                y: VideoCellConstants.videoImageInsets.top + imageHeight + VideoCellConstants.videoNameInsets.top),
            size: CGSize.zero)
        
        var videoNameWidth: CGFloat = AppConstants.screenWidth - VideoCellConstants.cardViewOffset.left - VideoCellConstants.cardViewOffset.right - VideoCellConstants.channelIconInsets.left - VideoCellConstants.channelIconSize - VideoCellConstants.videoNameInsets.left - VideoCellConstants.videoNameInsets.right
        
        if !videoNameText.isEmpty {
            var height = videoNameText.height(width: videoNameWidth, font: VideoCellConstants.videoNameFont)
            
            // check limit height for name label
            let limitHeight = VideoCellConstants.videoNameFont.lineHeight * VideoCellConstants.videoNameFontMaxLines
            
            if height > limitHeight {
                height = VideoCellConstants.videoNameFont.lineHeight * VideoCellConstants.videoNameFontMaxLines
            }
            
            videoNameRect.size = CGSize(width: videoNameWidth, height: height)
        }
        
        // MARK: Calculate videoDetails frame
        var videoDetailsRect = CGRect(origin: CGPoint(
            x: VideoCellConstants.channelIconInsets.left + VideoCellConstants.channelIconSize + VideoCellConstants.videoDetailsInsets.left,
            y: videoNameRect.maxY + VideoCellConstants.videoDetailsInsets.top), size: CGSize.zero)
        
        var videoDetailsWidth: CGFloat = AppConstants.screenWidth - VideoCellConstants.cardViewOffset.left - VideoCellConstants.cardViewOffset.right - VideoCellConstants.channelIconInsets.left - VideoCellConstants.channelIconSize - VideoCellConstants.videoNameInsets.left - VideoCellConstants.videoNameInsets.right
        
        if !detailsString.isEmpty {
            var height = detailsString.height(width: videoDetailsWidth, font: VideoCellConstants.videoDetailsFont)
            
            // check limit height for details label
            let limitHeight = VideoCellConstants.videoDetailsFont.lineHeight * VideoCellConstants.videoDetailsFontMaxLines
            
            if height > limitHeight {
                height = VideoCellConstants.videoDetailsFont.lineHeight * VideoCellConstants.videoDetailsFontMaxLines
            }
            
            videoDetailsRect.size = CGSize(width: videoNameWidth, height: height)
        }
        
        // MARK: TableView cell height
        // in case video name is in one line
        let minTableViewCellHeight: CGFloat = VideoCellConstants.cardViewOffset.top + VideoCellConstants.cardViewOffset.bottom + imageHeight + VideoCellConstants.videoImageInsets.top + VideoCellConstants.videoImageInsets.top + VideoCellConstants.videoImageInsets.bottom + VideoCellConstants.channelIconSize
        let tableViewCellHeight: CGFloat = max(minTableViewCellHeight,
                                               videoDetailsRect.maxY + VideoCellConstants.videoDetailsInsets.bottom + VideoCellConstants.cardViewOffset.top + VideoCellConstants.cardViewOffset.bottom)
        
        return VideoViewModel.Sizes(imageFrame: imageFrame,
                                    tableViewCellHeight: tableViewCellHeight,
                                    videoNameFrame: videoNameRect,
                                    videoDetailsFrame: videoDetailsRect)
    }
    
    // TODO: rename and return only height
    static func calculateVideoPlayerHeight(thumbnailSize: CGSize) -> CGFloat {
        let aspectRatio: CGFloat = thumbnailSize.height / thumbnailSize.width
        let imageWidth = AppConstants.screenWidth
        let imageHeight = imageWidth * aspectRatio
        return imageHeight
    }
}
