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
        getRecommendedVideos()
        //performSearch(for: "Gg")
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
    
    func getRecommendedVideos() {
        interactor?.getRecommendedVideos()
    }
    
    func performSearch(for search: String) {
        var finalSearchString = search
        if finalSearchString.contains(" "){
            guard let searchWithSpaces = finalSearchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Couldn't replace spaces")
                return
            }
            finalSearchString = searchWithSpaces
        }
        let preparedSearch: String = YouTubeHelper.getVideosSearchRequestString(for: finalSearchString)
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
            
            for rawVideoItem in data.rawVideItems {
                
                // MARK: for aspect ratio calculation
                guard let width = rawVideoItem.videoThumbnailSizeInfo.width, let height = rawVideoItem.videoThumbnailSizeInfo.height else { print("Error calculating sizes"); continue }
                
                // MARK: other small data
                let channelImageUrl = AppConstants.preferHttpForStaticContent ? rawVideoItem.channelImageUrl.replacingOccurrences(of: "https", with: "http") : rawVideoItem.channelImageUrl
                let videoNameText = rawVideoItem.videoTitle
                
                // MARK: Details String
                var dateString = "No Date"
                if !rawVideoItem.videoPublishTime.isEmpty {
                    dateString = DateHelpers.getTimeSincePublication(from: rawVideoItem.videoPublishTime)
                }
                let viewCount: Int = Int(rawVideoItem.videoViewsCount) ?? 0
                let viewsCountString: String = "\(viewCount.roundedWithAbbreviations) views"
                let detailsString = "\(rawVideoItem.channelTitle) ◦ \(viewsCountString) ◦ \(dateString)"
                
                // MARK: Calculate Sizes with data provided
                let cellSizes = YouTubeVideoSearchCellLayoutCalculator.calculateYTCellSizes(imageWidth: CGFloat(width), imageHeight: CGFloat(height), videoNameText: videoNameText, detailsString: detailsString)
                
                // MARK: Gather and preapre other YouTube statistics:
                
                let channelSubsCount: Int = Int(rawVideoItem.channelSubscribersCount) ?? 0
                let commentsCount: Int = Int(rawVideoItem.videoCommentsCount) ?? 0
                let commentsCountString: String = String(commentsCount.roundedWithAbbreviations)
                
                let videoDetails = VideoViewModel.VideoDetails(videoName: videoNameText, channelName: rawVideoItem.channelTitle, channelSubscribersCount: "\(channelSubsCount.roundedWithAbbreviations) subscribers", videoDetailsViewsDatePrepared: "\(viewsCountString) ◦ \(dateString)", likesCount: rawVideoItem.videoLikesCount, commentsCount: commentsCountString)
                
                // MARK: Final ViewModel:
                let videoModel = VideoViewModel(videoId: rawVideoItem.videoId, thumbnailUrl: rawVideoItem.videoThumbnailSizeInfo.url, channelImageUrl: channelImageUrl, videoNameString: rawVideoItem.videoTitle, detailsString: detailsString,
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
