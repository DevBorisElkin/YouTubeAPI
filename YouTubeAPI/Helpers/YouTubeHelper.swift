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
        return "https://www.googleapis.com/youtube/v3/channels?part=statistics&part=snippet&id=\(channelIds)&fields=items(statistics%2Cid%2Csnippet%2Fthumbnails)&key=\(apiKey)"
    }
    
    static func getVideosStatisticsRequestString(for channelIds: String) -> String {
        var ids = channelIds
        if ids.contains(","){
            ids = channelIds.replacingOccurrences(of: ",", with: "%2C")
        }
        return "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&maxResults=\(50)&id=\(ids)&key=\(apiKey)"
    }
    
    static func getCommentsForVideoRequestString(forVideoId videoId: String) -> String {
        return "https://www.googleapis.com/youtube/v3/commentThreads?key=\(apiKey)&textFormat=plainText&part=snippet&videoId=\(videoId)&maxResults=\(100)"
    }
    
    static func getCommentsForVideoRequestString(forVideoId videoId: String, forPageToken pageToken: String) -> String {
        return "https://www.googleapis.com/youtube/v3/commentThreads?key=\(apiKey)&textFormat=plainText&part=snippet&pageToken=\(pageToken)&videoId=\(videoId)&maxResults=\(100)"
    }
    
    // MARK: Get recommended videos (most popular)
    
    //
    
    static func getRecommendedVideosRequestString() -> String {
        return "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&chart=mostPopular&maxResults=\(50)&regionCode=\("US")&key=\(apiKey)"
    }
}
