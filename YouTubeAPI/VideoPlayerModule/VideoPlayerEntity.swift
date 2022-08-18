//
//  VideoPlayerEntity.swift
//  YouTubeAPI
//
//  Created by test on 13.08.2022.
//

import Foundation
import UIKit

struct VideoToShow {
    var videoId: String // needed to player to load vide
    var videoDetails: VideoViewModel.VideoDetails
    var sizes: Sizes
    
    struct Sizes {
        var playerHeight: CGFloat
        var videoNameFrame: CGRect
        var videoDetailsFrame: CGRect
    }
}
