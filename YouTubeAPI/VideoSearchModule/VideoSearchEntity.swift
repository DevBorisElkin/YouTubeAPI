//
//  VideoSearchEntity.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation

struct SearchResultWrapped: Decodable {
    var kind: String
    var etag: String
    var nextPageToken: String
    var regionCode: String
    var pageInfo: PageInfo
    var items: [Item]
}

struct PageInfo: Decodable {
    var totalResults: Int
    var resultsPerPage: Int
}

struct Item: Decodable {
    var kind: String
    var etag: String
    var id: IdInfo
    var snippet: SnippetInfo
}

struct IdInfo: Decodable {
    var kind: String
    var videoId: String?
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
