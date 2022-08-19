//
//  VideoViewModel.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation
import UIKit

typealias VideoChannelPairIncomplete = (videoItem: VideoItem, channelInfo: ChannelInfo)
typealias VideoChannelPair = (videoItem: VideoItem, channelInfo: ChannelInfo, videoStatistics: VideoStatistics)

struct VideoIntermediateViewModel {
    var videoChannelPairs: [VideoChannelPair]
}

struct VideoViewModel {
    var videoId: String? // just in case still keep it here
    
    var thumbnailUrl: String
    var channelImageUrl: String?
    
    var videoNameString: String
    var detailsString: String
    
    var sizes: Sizes
    var videoDetails: VideoDetails
    
    struct Sizes {
        var imageFrame: CGRect
        var tableViewCellHeight: CGFloat
        var videoNameFrame: CGRect
        var videoDetailsFrame: CGRect
    }
    
    // todo maybe make a new request?
    struct VideoDetails {
        var videoName: String
        var channelName: String
        var channelSubscribersCount: String
        var videoDetailsViewsDatePrepared: String
        var likesCount: String
        var commentsCount: String
    }
}
