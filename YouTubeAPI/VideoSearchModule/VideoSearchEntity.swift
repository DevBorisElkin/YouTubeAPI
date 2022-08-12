//
//  VideoSearchEntity.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation

// MARK: For videos request
struct SearchResultWrapped: Decodable {
    var kind: String
    var etag: String
    var nextPageToken: String
    var regionCode: String
    var pageInfo: PageInfo
    var items: [VideoItem]
}

struct PageInfo: Decodable {
    var totalResults: Int
    var resultsPerPage: Int
}

struct VideoItem: Decodable {
    var kind: String
    var etag: String
    var id: IdInfo
    var snippet: SnippetInfo
}

struct IdInfo: Decodable {
    var kind: String
    //var channelId: String? // for channels only
    var videoId: String? // for videos only
}

struct SnippetInfo: Decodable {
    var publishedAt: String
    var channelId: String?
    var title: String
    var description: String
    var thumbnails: ThumbnailInfo
    var channelTitle: String
    var liveBroadcastContent: String
    var publishTime: String
}

struct ThumbnailInfo: Decodable {
    var def: ThumbnailSizeInfo
    var medium: ThumbnailSizeInfo
    var high: ThumbnailSizeInfo
    
    private enum CodingKeys : String, CodingKey {
        case def = "default", medium, high
    }
}

struct ThumbnailSizeInfo: Decodable {
    var url: String
    var width: Int?
    var height: Int?
}

// MARK: For channels base info request

struct ChannelResultWrapped: Decodable {
    var items: [ChannelInfo]
}

struct ChannelInfo: Decodable {
    var id: String
    var snippet: Snippet
}

struct Snippet: Decodable {
    var thumbnails: Thumbnails
}

struct Thumbnails: Decodable {
    var def: ThumbnailSizeInfo
    var medium: ThumbnailSizeInfo
    var high: ThumbnailSizeInfo
    
    private enum CodingKeys : String, CodingKey {
        case def = "default", medium, high
    }
}

// MARK: For additional request to get video statistics (views count)

struct StatisticsWrapped: Decodable {
    var kind: String
    var etag: String
    var items: [VideoStatistics]
    var pageInfo: [String : Int]
}

struct VideoStatistics: Decodable {
    var kind: String
    var etag: String
    var id: String
    var statistics: StatisticsMetrics
}

struct StatisticsMetrics: Decodable {
    var viewCount: String?
    var likeCount: String?
    var favoriteCount: String?
    var commentCount: String?
}
