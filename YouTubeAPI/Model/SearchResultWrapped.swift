//
//  SearchResultWrapped.swift
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
}

struct PageInfo: Decodable {
    var totalResults: Int
    var resultsPerPage: Int
}
