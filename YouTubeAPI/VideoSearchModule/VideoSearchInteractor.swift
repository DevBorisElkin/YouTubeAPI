//
//  VideoSearchInteractor.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation

class VideoSearchInteractor: VideoSearchPresenterToInteractorProtocol {
    
    var presenter: VideoSearchInteractorToPresenterProtocol?
    
    func performVideoSearch(for search: String) {
        
        Task.detached(priority: .medium) {
            
            // MARK: LOAD VIDEOS
            let videosData: SearchResultWrapped? = try? await NetworkingHelpers.loadDataFromUrlString(from: search)
            guard let videosData = videosData else { print("search failed"); return }
            
            // MARK: PREPARE CHANNEL IDS STRING
            let channelIdsString = self.convertVideoSearchToListOfChannelIds(with: videosData)
            guard !channelIdsString.isEmpty, let channelsRequestUrl = URL(string: YouTubeHelper.getChannelsInfoRequestString(for: channelIdsString)) else {
                print("Empty channel ids or bad url");
                return
            }
            
            // MARK: LOAD CHANNELS DATA
            let channelsData: ChannelResultWrapped? = try? await NetworkingHelpers.loadDataFromURL(from: channelsRequestUrl)
            guard let channelsData = channelsData else { print("channel request failed"); return }

            // MARK: CREATE ASOCIATED PAIRS OF VIDEO-CHANNEL
            var videoChannelPairs: [VideoChannelPairIncomplete] = []
            
            for video in videosData.items {
                let relatedChannel = channelsData.items.first { $0.id == video.snippet.channelId }
                guard let relatedChannel = relatedChannel else { continue }
                videoChannelPairs.append((video, relatedChannel))
            }
            
            // MARK: CREATE URL FOR REQUEST TO GET MULTIPLE VIDEO STATS WITH ONE NETWORK REQUEST
            let videoIdsString: String = self.getVideoIds(from: videosData)
            
            guard !videoIdsString.isEmpty, let statisticsUrl = URL(string: YouTubeHelper.getVideosStatisticsRequestString(for: videoIdsString)) else {
                print("empty videoIdsString or bad statistics url")
                return
            }
            
            // MARK: LOAD VIDEOS STATS
            let statisticsData: StatisticsWrapped? = try? await NetworkingHelpers.loadDataFromURL(from: statisticsUrl)
            guard let statisticsData = statisticsData else { print("failed getting video statistics"); return }
            
            // MARK: CREATE ASOCIATED PAIRS OF VIDEO-CHANNEL-VIDEO_DETAILS
            var completeVideoResultPairs: [VideoChannelPair] = []
            for pair in videoChannelPairs {
                let pairStatistics = statisticsData.items.first { $0.id == pair.videoItem.id.videoId }
                guard let pairStatistics = pairStatistics else { print("No statistics pair detected"); continue }
                
                completeVideoResultPairs.append((pair.videoItem, pair.channelInfo, pairStatistics))
            }
            
            // MARK: CONTINUE WITH AQUIRED DATA
            let videoItemIntermediateViewModel = VideoIntermediateViewModel(videoChannelPairs: completeVideoResultPairs)
            self.presenter?.receivedData(result: .success(videoItemIntermediateViewModel))
        }
    }
    
    func convertVideoSearchToListOfChannelIds(with data: SearchResultWrapped) -> String {
        var ids = ""
        for i in 0 ..< data.items.count {
            if let channelId = data.items[i].snippet.channelId {
                if(i < data.items.count - 1){
                    ids += "\(channelId),"
                }else{
                    ids += channelId
                }
            }
        }
        return ids
    }
    
    func getVideoIds(from searchResult: SearchResultWrapped) -> String {
        var ids = ""
        for i in 0 ..< searchResult.items.count {
            if let videoId = searchResult.items[i].id.videoId {
                if(i < searchResult.items.count - 1){
                    ids += "\(videoId),"
                }else{
                    ids += videoId
                }
            }
        }
        return ids
    }
}
