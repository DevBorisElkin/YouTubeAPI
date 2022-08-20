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
    var channelInfoViewModel: ChannelInfoViewModel
    var sizes: Sizes
    
    struct Sizes {
        var playerHeight: CGFloat
        var videoNameFrame: CGRect
        var videoDetailsFrame: CGRect
        var channelInfoFrame: CGRect
    }
}

struct ChannelInfoViewModel {
    var channelName: String
    var subscribersCount: String
    var channelIconUrlString: String
}

// Comments related

struct CommentViewModel {
    var commentId: String
    var userDateEditedCombinedString: String
    var commentText: String
    var authorProfileImageUrl: String
    var likeCount: String
    var totalReplyCount: String
    var sizes: CommentCellSizes
    
    struct CommentCellSizes {
        var commentAuthorIconFrame: CGRect
        var topTextFrame: CGRect
        var commentTextFrame: CGRect
        var expandCommentTextButtonFrame: CGRect
        var repliesCountLabelFrame: CGRect
        var tableViewCellHeight: CGFloat
    }
}


