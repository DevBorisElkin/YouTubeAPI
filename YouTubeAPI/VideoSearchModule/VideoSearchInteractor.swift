//
//  VideoSearchInteractor.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation

class VideoSearchInteractor: VideoSearchPresenterToInteractorProtocol {
    
    func performSearch(for search: String) {
        print("Performin request for string: \(search)")
        NetworkingHelpers.decodeDataWithResult(from: search, type: SearchResultWrapped.self, printJSON: true) { [weak self] result in
            
            switch result{
            case .success(let videosData):
                print("success fetching data")
                
                let channelIds = self?.convertVideoSearchToListOfChannelIds(with: videosData) ?? ""
                guard !channelIds.isEmpty else { print("Empty channel ids"); return }
                
                let requestString = YouTubeHelper.getChannelsInfoRequestString(for: channelIds)
                
                NetworkingHelpers.decodeDataWithResult(from: requestString, type: ChannelResultWrapped.self, printJSON: true) { [weak self] result in
                    switch result {
                        
                    case .success(let channelsData):
                        print("success fetching channels data")
                        
                        var videoChannelPairs: [VideoChannelPairIncomplete] = []
                        
                        for video in videosData.items {
                            var relatedChannel = channelsData.items.first { $0.id == video.snippet.channelId
                            }
                            if let relatedChannel = relatedChannel {
                                var pair: VideoChannelPairIncomplete = (video, relatedChannel)
                                videoChannelPairs.append(pair)
                            }
                        }
                        
                        print("PAIRS COUNT: \(videoChannelPairs.count)")
                        
                        var videoIdsString: String = self?.getVideoIds(from: videosData) ?? ""
                        print("videoIdsString: \(videoIdsString)")
                        
                        NetworkingHelpers.decodeDataWithResult(from: YouTubeHelper.getVideosStatisticsRequestString(for: videoIdsString), type: StatisticsWrapped.self, printJSON: true) { statisticsResult in
                            switch statisticsResult {
                            case .success(let statistics):
                                print("success retriving statistics")
                                
                                var completeVideoResultPairs: [VideoChannelPair] = []
                                for pair in videoChannelPairs {
                                    var pairStatistics = statistics.items.first { $0.id == pair.videoItem.id.videoId }
                                    guard let pairStatistics = pairStatistics else { print("No statistics pair detected"); continue }
                                    
                                    completeVideoResultPairs.append((pair.videoItem, pair.channelInfo, pairStatistics))
                                }
                                var videoItemIntermediateViewModel = VideoIntermediateViewModel(videoChannelPairs: completeVideoResultPairs)
                                self?.presenter?.receivedData(result: .success(videoItemIntermediateViewModel))
                                
                            case .failure(let errorStatistics):
                                print(errorStatistics)
                            }
                        }
                        
                    case .failure(let error):
                        print("failue fetching channels data, \(error)")
                    }
                }
                
            case .failure(let error):
                print("failue fetching data, \(error)")
            }
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
    
    var presenter: VideoSearchInteractorToPresenterProtocol?
    
    
}
