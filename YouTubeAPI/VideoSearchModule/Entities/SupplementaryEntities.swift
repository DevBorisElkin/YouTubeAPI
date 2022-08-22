//
//  SupplementaryEntities.swift
//  YouTubeAPI
//
//  Created by test on 22.08.2022.
//

import Foundation

enum VideosRequestType {
    case recommendedFeed(requestPurpose: RequestPurpose, pageToken: String?)
    case searchRequest(requestPurpose: RequestPurpose, request: String, pageToken: String?)

    enum RequestPurpose {
        case refresh
        case append
    }
}


