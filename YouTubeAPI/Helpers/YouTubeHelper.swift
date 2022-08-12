//
//  YouTubeHelper.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation

class YouTubeHelper {
    static let apiKey = "AIzaSyD5fpfVfQl5NWUNUpS5EhdhK2HB7pzUVNc"
    
    static let maxResults = 50 // 0 to 50 inclusive
    
    static func getRequestString(for request: String) -> String {
        return "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=\(maxResults)&q=\(request)&videoDuration=videoDurationUnspecified&key=\(apiKey)"
    }
    
    static func getChannelsInfoRequestString(for channelIds: String) -> String {
        return "https://www.googleapis.com/youtube/v3/channels?part=snippet&id=\(channelIds)&fields=items(id%2Csnippet%2Fthumbnails)&key=\(apiKey)"
    }
    
    static func getVideosStatisticsRequestString(for channelIds: String) -> String {
        var ids = channelIds
        if ids.contains(","){
            ids = channelIds.replacingOccurrences(of: ",", with: "%2C")
        }
        return "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&maxResults=\(50)&id=\(ids)&key=\(apiKey)"
    }
}
