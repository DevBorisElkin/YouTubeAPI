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
    
    private var lastRequestDetails: VideosRequestType?
    private var nextPageToken: String?
    
    func viewDidLoad() {
        getVideos(requestDetails: .recommendedFeed(requestPurpose: .refresh, pageToken: nil))
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
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        return searchResults[indexPath.row].sizes.tableViewCellHeight
    }
    
    // MARK: Logic related
    
    func refresh() {
        guard let lastRequestDetails = lastRequestDetails else {
            return
        }
        let newRequest: VideosRequestType!
        
        switch lastRequestDetails {
        case .recommendedFeed(let requestPurpose, let pageToken):
            newRequest = .recommendedFeed(requestPurpose: .refresh, pageToken: nil)
        case .searchRequest(let requestPurpose, let request, let pageToken):
            newRequest = .searchRequest(requestPurpose: .refresh, request: request, pageToken: nil)
        }
        
        getVideos(requestDetails: newRequest)
    }
    
    func videosPaginationRequest() {
        guard let lastRequestDetails = lastRequestDetails else {
            print("No previous request")
            return
        }
        
        let newRequest: VideosRequestType!
        
        switch lastRequestDetails {
        case .recommendedFeed(let requestPurpose, let pageToken):
            newRequest = .recommendedFeed(requestPurpose: .append, pageToken: nextPageToken)
        case .searchRequest(let requestPurpose, let request, let pageToken):
            newRequest = .searchRequest(requestPurpose: .append, request: request, pageToken: nextPageToken)
        }
        
        getVideos(requestDetails: newRequest)
    }
    
    func getVideos(requestDetails: VideosRequestType) {
        lastRequestDetails = requestDetails
        
        switch requestDetails {
        case .recommendedFeed(requestPurpose: let requestPurpose, _):
            
            let request: VideosRequestType = .recommendedFeed(requestPurpose: requestPurpose, pageToken: nextPageToken)
            
            view?.onFetchVideosListStarted()
            interactor?.performVideosSearch(requestType: request)
        
        case .searchRequest(requestPurpose: let requestPurpose, request: let request, _):
            var finalSearchString = request
            if finalSearchString.contains(" "){
                guard let searchWithSpaces = finalSearchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    print("Couldn't replace spaces")
                    return
                }
                finalSearchString = searchWithSpaces
            }
            let preparedSearch: String = YouTubeHelper.getVideosSearchRequestString(for: finalSearchString, forPageToken: nextPageToken)
            
            let request: VideosRequestType = .searchRequest(requestPurpose: requestPurpose, request: preparedSearch, pageToken: nextPageToken)
            
            view?.onFetchVideosListStarted()
            interactor?.performVideosSearch(requestType: request)
        }
    }
}

extension VideoSearchPresenter: VideoSearchVideoCellToPresenterProtocol {
    func requestedToOpenVideo(with viewModel: VideoViewModel) {
        print("presenter: requested to open video")
        router?.pushToVideoPlayer(on: view, with: viewModel)
    }
}

extension VideoSearchPresenter: VideoSearchInteractorToPresenterProtocol {
    
    func onVideosLoadingFailed(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.onFetchVideosListFail(error: error)
        }
    }
    
    func receivedData(result: VideoIntermediateViewModel, requestPurpose: VideosRequestType.RequestPurpose, nextPageToken: String?) {
        
        var finalData = result
        print("Successfully received data")
        
        self.nextPageToken = nextPageToken
        
        if requestPurpose == .refresh {
            searchResults = []
        } else if requestPurpose == .append {
            print("Upcoming items count: \(finalData.rawVideItems.count)")
            finalData.rawVideItems = finalData.rawVideItems.filter({ item in
                let videoAlreadyInTheList = searchResults.contains {$0.videoId == item.videoId}
                return !videoAlreadyInTheList
            })
            print("Items left after filtering: \(finalData.rawVideItems.count)")
        }
        
        for rawVideoItem in finalData.rawVideItems {
            
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
    }
}
