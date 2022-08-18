//
//  YouTubeVideoCellLayoutCalculator.swift
//  YouTubeAPI
//
//  Created by test on 18.08.2022.
//

import Foundation
import UIKit

class YouTubeVideoCellLayoutCalculator {
    
    static func calculateVideoCellSizes(thumbnailSize: CGSize, videoDetails: VideoViewModel.VideoDetails) -> VideoToShow.Sizes {
        
        // MARK: Caulculate videoPlayerHeight
        let aspectRatio: CGFloat = thumbnailSize.height / thumbnailSize.width
        let imageWidth = AppConstants.screenWidth
        let playerHeight = imageWidth * aspectRatio
        
        // MARK: Calculate videoName frame
        var videoNameRect = CGRect(
            origin: CGPoint(
                x: VideoPlayerConstants.videoNameInsets.left,
                y: playerHeight + VideoPlayerConstants.videoNameInsets.top),
            size: CGSize.zero)
        
        let videoNameWidth: CGFloat = AppConstants.screenWidth - VideoPlayerConstants.videoNameInsets.left - VideoPlayerConstants.videoNameInsets.right
        
        if !videoDetails.videoName.isEmpty {
            var height = videoDetails.videoName.height(width: videoNameWidth, font: VideoPlayerConstants.videoNameFont)
            
            // check limit height for name label
            let limitHeight = VideoPlayerConstants.videoNameFont.lineHeight * VideoPlayerConstants.videoNameFontMaxLines
            
            if height > limitHeight {
                height = VideoPlayerConstants.videoNameFont.lineHeight * VideoPlayerConstants.videoNameFontMaxLines
            }
            
            videoNameRect.size = CGSize(width: videoNameWidth, height: height)
        }
        
        // MARK: Calculate videoDetails frame
        var videoDetailsRect = CGRect(origin: CGPoint(
            x: VideoPlayerConstants.videoDetailsInsets.left,
            y: videoNameRect.maxY + VideoPlayerConstants.videoDetailsInsets.top), size: CGSize.zero)
        
        let videoDetailsWidth: CGFloat = AppConstants.screenWidth - VideoPlayerConstants.videoDetailsInsets.left - VideoPlayerConstants.videoDetailsInsets.right
        
        if !videoDetails.videoDetailsViewsDatePrepared.isEmpty {
            var height = videoDetails.videoDetailsViewsDatePrepared.height(width: videoDetailsWidth, font: VideoPlayerConstants.videoDetailsFont)
            
            // check limit height for details label
            let limitHeight = VideoCellConstants.videoDetailsFont.lineHeight * VideoPlayerConstants.videoDetailsFontMaxLines
            
            if height > limitHeight {
                height = VideoPlayerConstants.videoDetailsFont.lineHeight * VideoPlayerConstants.videoDetailsFontMaxLines
            }
            
            videoDetailsRect.size = CGSize(width: videoNameWidth, height: height)
        }
        
        return VideoToShow.Sizes(playerHeight: playerHeight, videoNameFrame: videoNameRect, videoDetailsFrame: videoDetailsRect)
    }
}
