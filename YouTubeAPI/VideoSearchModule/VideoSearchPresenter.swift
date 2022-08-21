//
//  VideoSearchPresenter.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation
import UIKit

class VideoSearchPresenter: VideoSearchViewToPresenterProtocol {
    weak var view: VideoSearchPresenterToViewProtocol?
    var interactor: VideoSearchPresenterToInteractorProtocol?
    var router: VideoSearchPresenterToRouterProtocol?
    
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
        cell.presenter = self
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

extension VideoSearchPresenter: VideoSearchVideoCellToPresenterProtocol {
    func requestedToOpenVideo(with viewModel: VideoViewModel) {
        print("presenter: requested to open video")
        
        // here I could go to interactor and request more data, but for now would be enough just to move to new VC with existing data
        router?.pushToVideoPlayer(on: view, with: viewModel)
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
                let channelImageUrl = AppConstants.preferHttpForStaticContent ? pair.channelInfo.snippet.thumbnails.def.url.replacingOccurrences(of: "https", with: "http") : pair.channelInfo.snippet.thumbnails.def.url
                let videoNameText = pair.videoItem.snippet.description
                
                // MARK: Details String
                let dateString = DateHelpers.getTimeSincePublication(from: pair.videoItem.snippet.publishTime)
                let viewCount: Int = Int((pair.videoStatistics.statistics.viewCount ?? "0")) ?? 0
                let viewsCountString: String = "\(viewCount.roundedWithAbbreviations) views"
                let detailsString = "\(pair.videoItem.snippet.channelTitle) ◦ \(viewsCountString) ◦ \(dateString)"
                
                // MARK: Calculate Sizes with data provided
                let cellSizes = YouTubeVideoSearchCellLayoutCalculator.calculateYTCellSizes(imageWidth: CGFloat(width), imageHeight: CGFloat(height), videoNameText: videoNameText, detailsString: detailsString)
                
                // MARK: Gather and preapre other YouTube statistics:
                
                let channelSubsCount: Int = Int(pair.channelInfo.statistics.subscriberCount) ?? 0
                let commentsCount: Int = Int(pair.videoStatistics.statistics.commentCount ?? "0") ?? 0
                let commentsCountString: String = String(commentsCount.roundedWithAbbreviations)
                
                let videoDetails = VideoViewModel.VideoDetails(videoName: videoNameText, channelName: pair.videoItem.snippet.channelTitle, channelSubscribersCount: "\(channelSubsCount.roundedWithAbbreviations) subscribers", videoDetailsViewsDatePrepared: "\(viewsCountString) ◦ \(dateString)", likesCount: pair.videoStatistics.statistics.likeCount ?? "0", commentsCount: commentsCountString)
                
                // MARK: Final ViewModel:
                let videoModel = VideoViewModel(videoId: pair.videoItem.id.videoId, thumbnailUrl: sizeInfo.url, channelImageUrl: channelImageUrl, videoNameString: pair.videoItem.snippet.description, detailsString: detailsString,
                                                sizes: cellSizes, videoDetails: videoDetails)
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
