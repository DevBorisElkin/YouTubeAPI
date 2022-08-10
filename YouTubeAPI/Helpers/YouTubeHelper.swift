//
//  YouTubeHelper.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation

class YouTubeHelper {
    static let apiKey = "AIzaSyD5fpfVfQl5NWUNUpS5EhdhK2HB7pzUVNc"
    
    static func getRequestString(for request: String) -> String {
        return "https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=\(request)&videoDuration=videoDurationUnspecified&key=\(apiKey)"
    }
}
