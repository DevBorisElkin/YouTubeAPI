//
//  VideoViewModel.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation
import UIKit

typealias VideoChannelPair = (videoItem: VideoItem, channelInfo: ChannelInfo)

struct VideoIntermediateViewModel {
    var videoChannelPairs: [VideoChannelPair]
}

struct VideoViewModel {
    var videoId: String? // just in case still keep it here
    
    var thumbnailUrl: String
    var channelImageUrl: String?
    
    var videoNameString: String
    var detailsString: String
    
    var imageFrame: CGRect
    var tableViewCellHeight: CGFloat
    
    var videoNameFrame: CGRect
    var videoDetailsFrame: CGRect
}
