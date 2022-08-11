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
                
                NetworkingHelpers.decodeDataWithResult(from: requestString, type: ChannelResultWrapped.self, printJSON: true) { result in
                    switch result {
                        
                    case .success(let channelsData):
                        print("success fetching channels data")
                        
                        var videoChannelPairs: [VideoChannelPair] = []
                        
                        for video in videosData.items {
                            var relatedChannel = channelsData.items.first { $0.id == video.snippet.channelId
                            }
                            if let relatedChannel = relatedChannel {
                                var pair: VideoChannelPair = (video, relatedChannel)
                                videoChannelPairs.append(pair)
                            }
                        }
                        
                        print("PAIRS COUNT: \(videoChannelPairs.count)")
                        
                        var videoItemIntermediateViewModel = VideoIntermediateViewModel(videoChannelPairs: videoChannelPairs)
                        
                        self?.presenter?.receivedData(result: .success(videoItemIntermediateViewModel))
                        
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
    
    var presenter: VideoSearchInteractorToPresenterProtocol?
    
    
}
