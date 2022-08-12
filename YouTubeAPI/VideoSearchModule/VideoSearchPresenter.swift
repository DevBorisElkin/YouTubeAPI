//
//  VideoSearchPresenter.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation
import UIKit

class VideoSearchPresenter: VideoSearchViewToPresenterProtocol {
    var view: VideoSearchPresenterToViewProtocol?
    var interactor: VideoSearchPresenterToInteractorProtocol?
    var router: VideoSearchPresenterToRouterProtocol?
    
    // TODO fill real data
    var searchResults: [VideoViewModel] = []
    
    func viewDidLoad() {
        performSearch(for: "Gg")
    }
    
    func refresh() {
        
    }
    
    // MARK: For table view
    func numberOfRowsInSection() -> Int {
        return searchResults.count
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: YouTubeVideoSearchCell.reuseId, for: indexPath) as! YouTubeVideoSearchCell
        cell.setUp(viewModel: searchResults[indexPath.row])
        return cell
    }
    
    func didSelectRowAt(index: Int) {
        // do nothing for now
    }
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        return searchResults[indexPath.row].sizes.tableViewCellHeight
    }
    
    // MARK: Logic related
    func performSearch(for search: String) {
        var finalSearchString = search
        if finalSearchString.contains(" "){
            guard let searchWithSpaces = finalSearchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Couldn't replace spaces")
                return
            }
            finalSearchString = searchWithSpaces
        }
        let preparedSearch: String = YouTubeHelper.getRequestString(for: finalSearchString)
        interactor?.performVideoSearch(for: preparedSearch)
    }
}

extension VideoSearchPresenter: VideoSearchInteractorToPresenterProtocol {
    func receivedData(result: Result<VideoIntermediateViewModel, Error>) {
        
        switch result {
        case .success(let data):
            print("Successfully received data")
            
            searchResults = []
            
            for pair in data.videoChannelPairs {
                guard pair.videoItem.id.videoId != nil else { continue } // filter out everything except videos
                
                // MARK: for aspect ratio calculation
                let sizeInfo = pair.videoItem.snippet.thumbnails.medium // use medium probably
                guard let width = sizeInfo.width, let height = sizeInfo.height else { print("Error calculating sizes"); continue }
                
                // MARK: other small data
                let channelImageUrl = pair.channelInfo.snippet.thumbnails.def.url.replacingOccurrences(of: "https", with: "http")
                let videoNameText = pair.videoItem.snippet.description
                
                // MARK: Details String
                let dateString = DateHelpers.getTimeSincePublication(from: pair.videoItem.snippet.publishTime)
                let viewCount: Int = Int((pair.videoStatistics.statistics.viewCount ?? "0")) ?? 0
                let viewsCountString: String = "\(viewCount.roundedWithAbbreviations) views"
                let detailsString = "\(pair.videoItem.snippet.channelTitle) ◦ \(viewsCountString) ◦ \(dateString)"
                
                // MARK: Calculate Sizes with data provided
                let cellSizes = YouTubeVideoSearchCellLayoutCalculator.calculateYTCellSizes(imageWidth: CGFloat(width), imageHeight: CGFloat(height), videoNameText: videoNameText, detailsString: detailsString)
                
                let videoModel = VideoViewModel(videoId: pair.videoItem.id.videoId, thumbnailUrl: sizeInfo.url, channelImageUrl: channelImageUrl, videoNameString: pair.videoItem.snippet.description, detailsString: detailsString,
                                               sizes: cellSizes)
                searchResults.append(videoModel)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.onFetchVideosListSuccess()
            }
            
        case .failure(let error):
            print("Error receiving data: \(error)")
        }
        
    }
    
    
}
