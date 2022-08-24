//
//  VideoSearchInteractor.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation

class VideoSearchInteractor: VideoSearchPresenterToInteractorProtocol {
    
    func performVideosSearch(requestType: VideosRequestType) {
        switch requestType {
            
        case .recommendedFeed(requestPurpose: let requestPurpose, pageToken: let pageToken):
            getRecommendedVideos(requestPurpose: requestPurpose, pageToken: pageToken)
        case .searchRequest(requestPurpose: let requestPurpose, request: let request, pageToken: let pageToken):
            performVideoSearch(requestPurpose: requestPurpose, for: request, pageToken: pageToken)
        }
    }
    
    weak var presenter: VideoSearchInteractorToPresenterProtocol?
    
    private func getRecommendedVideos(requestPurpose: VideosRequestType.RequestPurpose, pageToken: String?) {
        Task.detached(priority: .medium) { [weak self] in
            // MARK: LOAD VIDEOS
            let requestString = YouTubeHelper.getRecommendedVideosRequestString(forPageToken: pageToken)
            let videosData: RecommendedVideosResultWrapped?
            let resultVideosData: Result<RecommendedVideosResultWrapped, Error>  = await NetworkingHelpers.loadDataFromUrlString(from: requestString, printJsonAndRequestString: false)
            
            switch resultVideosData {
            case .success(let data):
                videosData = data
            case .failure(let error):
                print(error)
                self?.presenter?.onVideosLoadingFailed(error: error)
                return
            }
            
            guard let videosData = videosData else {
                print("getting recommended videos failed");
                self?.presenter?.onVideosLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined)
                return
            }
            
            // MARK: PREPARE CHANNEL IDS STRING
            let channelIdsString = self?.convertRecommendedVideosToListOfChannelIds(with: videosData) ?? ""
            guard !channelIdsString.isEmpty, let channelsRequestUrl = URL(string: YouTubeHelper.getChannelsInfoRequestString(for: channelIdsString)) else {
                print("Empty channel ids or bad url");
                self?.presenter?.onVideosLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined)
                return
            }
            
            // MARK: LOAD CHANNELS DATA
            let channelsData: ChannelResultWrapped?
            let resultChannelData: Result<ChannelResultWrapped, Error>  = await NetworkingHelpers.loadDataFromUrl(from: channelsRequestUrl, printJsonAndRequestString: false)
            
            switch resultChannelData {
            case .success(let data):
                channelsData = data
            case .failure(let error):
                print(error)
                self?.presenter?.onVideosLoadingFailed(error: error)
                return
            }
            
            guard let channelsData = channelsData else {
                print("channel request failed");
                self?.presenter?.onVideosLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined)
                return }

            // MARK: CREATE ASOCIATED PAIRS OF VIDEO-CHANNEL
            var videoChannelPairs: [RecommendedVideoChannelPair] = []
            
            for video in videosData.items {
                let relatedChannel = channelsData.items.first { $0.id == video.snippet.channelId }
                guard let relatedChannel = relatedChannel else { continue }
                videoChannelPairs.append((video, relatedChannel))
            }
            
            // MARK: Map to common video intermediate result
            
            var rawVideoItems = [RawVideoItem]()
            for pair in videoChannelPairs {
                
                let rawVideoItem = RawVideoItem(
                    videoId: pair.videoItem.id,
                    videoTitle: pair.videoItem.snippet.title,
                    videoPublishTime: pair.videoItem.snippet.publishedAt,
                    videoThumbnailSizeInfo: pair.videoItem.snippet.thumbnails.medium,
                    channelTitle: pair.videoItem.snippet.channelTitle,
                    channelImageUrl: pair.channelInfo.snippet.thumbnails.def.url,
                    videoViewsCount: pair.videoItem.statistics.viewCount ?? "0",
                    videoLikesCount: pair.videoItem.statistics.likeCount ?? "0",
                    videoCommentsCount: pair.videoItem.statistics.commentCount ?? "0",
                    channelSubscribersCount: pair.channelInfo.statistics.subscriberCount)
                
                rawVideoItems.append(rawVideoItem)
            }
            
            // MARK: CONTINUE WITH ACQUIRED DATA
            let videoItemIntermediateViewModel = VideoIntermediateViewModel(rawVideItems: rawVideoItems)
            self?.presenter?.receivedData(result: videoItemIntermediateViewModel, requestPurpose: requestPurpose, nextPageToken: videosData.nextPageToken)
        }
    }
    
    private func performVideoSearch(requestPurpose: VideosRequestType.RequestPurpose, for search: String, pageToken: String?) {
        
        Task.detached(priority: .medium) { [weak self] in
            
            // MARK: LOAD VIDEOS
            let videosData: SearchResultWrapped?
            let resultVideosData: Result<SearchResultWrapped, Error>  = await NetworkingHelpers.loadDataFromUrlString(from: search, printJsonAndRequestString: false)
            
            switch resultVideosData {
            case .success(let data):
                videosData = data
            case .failure(let error):
                print(error)
                self?.presenter?.onVideosLoadingFailed(error: error)
                return
            }
            
            // filter out non-videos
            guard var videosData = videosData else {
                print("search failed");
                self?.presenter?.onVideosLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined)
                return }
            videosData.items = videosData.items.filter({ $0.id.videoId != nil })
            
            // MARK: PREPARE CHANNEL IDS STRING
            let channelIdsString = self?.convertVideoSearchToListOfChannelIds(with: videosData) ?? ""
            guard !channelIdsString.isEmpty, let channelsRequestUrl = URL(string: YouTubeHelper.getChannelsInfoRequestString(for: channelIdsString)) else {
                print("Empty channel ids or bad url");
                self?.presenter?.onVideosLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined)
                return
            }
            
            // MARK: LOAD CHANNELS DATA
            let channelsData: ChannelResultWrapped?
            let resultChannelData: Result<ChannelResultWrapped, Error>  = await NetworkingHelpers.loadDataFromUrl(from: channelsRequestUrl, printJsonAndRequestString: false)
            
            switch resultChannelData {
            case .success(let data):
                channelsData = data
            case .failure(let error):
                print(error)
                self?.presenter?.onVideosLoadingFailed(error: error)
                return
            }
            
            guard let channelsData = channelsData else { print("channel request failed"); return }

            // MARK: CREATE ASOCIATED PAIRS OF VIDEO-CHANNEL
            var videoChannelPairs: [VideoChannelPairIncomplete] = []
            
            for video in videosData.items {
                let relatedChannel = channelsData.items.first { $0.id == video.snippet.channelId }
                guard let relatedChannel = relatedChannel else { continue }
                videoChannelPairs.append((video, relatedChannel))
            }
            
            // MARK: CREATE URL FOR REQUEST TO GET MULTIPLE VIDEO STATS WITH ONE NETWORK REQUEST
            let videoIdsString: String = self?.getVideoIds(from: videosData) ?? ""
            
            guard !videoIdsString.isEmpty, let statisticsUrl = URL(string: YouTubeHelper.getVideosStatisticsRequestString(for: videoIdsString)) else {
                print("empty videoIdsString or bad statistics url")
                self?.presenter?.onVideosLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined)
                return
            }
            
            // MARK: LOAD VIDEOS STATS
            let statisticsData: StatisticsWrapped?
            let resultStatisticsData: Result<StatisticsWrapped, Error>  = await NetworkingHelpers.loadDataFromUrl(from: statisticsUrl, printJsonAndRequestString: false)
            
            switch resultStatisticsData {
            case .success(let data):
                statisticsData = data
            case .failure(let error):
                print(error)
                self?.presenter?.onVideosLoadingFailed(error: error)
                return
            }
            
            guard let statisticsData = statisticsData else {
                print("failed getting video statistics");
                self?.presenter?.onVideosLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined)
                return }
            
            // MARK: CREATE ASOCIATED PAIRS OF VIDEO-CHANNEL-VIDEO_DETAILS
            var completeVideoResultPairs: [VideoChannelPair] = []
            for pair in videoChannelPairs {
                let pairStatistics = statisticsData.items.first { $0.id == pair.videoItem.id.videoId }
                guard let pairStatistics = pairStatistics else { print("No statistics pair detected"); continue }
                
                completeVideoResultPairs.append((pair.videoItem, pair.channelInfo, pairStatistics))
            }
            
            // MARK: Map to common video intermediate result
            
            var rawVideoItems = [RawVideoItem]()
            for pair in completeVideoResultPairs {
                
                let rawVideoItem = RawVideoItem(videoId: pair.videoItem.id.videoId!, videoTitle: pair.videoItem.snippet.title, videoPublishTime: pair.videoItem.snippet.publishTime ?? "", videoThumbnailSizeInfo: pair.videoItem.snippet.thumbnails.medium, channelTitle: pair.videoItem.snippet.channelTitle, channelImageUrl: pair.channelInfo.snippet.thumbnails.def.url, videoViewsCount: pair.videoStatistics.statistics.viewCount ?? "0", videoLikesCount: pair.videoStatistics.statistics.likeCount ?? "0", videoCommentsCount: pair.videoStatistics.statistics.commentCount ?? "0", channelSubscribersCount: pair.channelInfo.statistics.subscriberCount)
                
                rawVideoItems.append(rawVideoItem)
            }
            
            // MARK: CONTINUE WITH ACQUIRED DATA
            let videoItemIntermediateViewModel = VideoIntermediateViewModel(rawVideItems: rawVideoItems)
            self?.presenter?.receivedData(result: videoItemIntermediateViewModel, requestPurpose: requestPurpose, nextPageToken: videosData.nextPageToken)
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
    
    func convertRecommendedVideosToListOfChannelIds(with data: RecommendedVideosResultWrapped) -> String {
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
