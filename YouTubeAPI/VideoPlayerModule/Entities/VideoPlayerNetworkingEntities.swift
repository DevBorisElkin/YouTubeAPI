//
//  VideoPlayerNetworkingEntities.swift
//  YouTubeAPI
//
//  Created by test on 19.08.2022.
//

import Foundation

struct CommentsResultWrapped: Decodable {
    var kind: String
    var etag: String
    var nextPageToken: String?
    var pageInfo: PageInfo
    var items: [CommentItem]?
}

struct CommentItem: Decodable {
    var kind: String
    var etag: String
    var id: String
    var snippet: CommentSnippet
}

struct CommentSnippet: Decodable {
    var videoId: String
    var topLevelComment: TopLevelComment
    var canReply: Bool
    var totalReplyCount: Int
    var isPublic: Bool
}

struct TopLevelComment: Decodable {
    var kind: String
    var etag: String
    var id: String
    var snippet: TopLevelCommentSnippet
}

struct TopLevelCommentSnippet: Decodable {
    var videoId: String
    var textDisplay: String
    var textOriginal: String
    var authorDisplayName: String
    var authorProfileImageUrl: String
    var authorChannelUrl: String
    var authorChannelId: [String : String]
    var canRate: Bool
    var viewerRating: String
    var likeCount: Int
    var publishedAt: String
    var updatedAt: String
}
