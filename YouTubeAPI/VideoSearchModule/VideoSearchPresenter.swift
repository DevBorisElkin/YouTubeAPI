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
        return searchResults[indexPath.row].tableViewCellHeight
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
        var preparedSearch: String = YouTubeHelper.getRequestString(for: finalSearchString)
        interactor?.performSearch(for: preparedSearch)
    }
}

extension VideoSearchPresenter: VideoSearchInteractorToPresenterProtocol {
    func receivedData(result: Result<VideoIntermediateViewModel, Error>) {
        
        switch result {
        case .success(let data):
            print("Successfully received data")
            
            searchResults = []
            data.videoChannelPairs.forEach { pair in
                guard pair.videoItem.id.videoId != nil else { return } // filter out everything except videos
                
                var aspectRatio: CGFloat = 1
                let sizeInfo = pair.videoItem.snippet.thumbnails.medium // use medium probably
                
                // MARK: calculate image aspect ratio
                if let width = sizeInfo.width, let height = sizeInfo.height  {
                    let widthF = CGFloat(width)
                    let heightF = CGFloat(height)
                    
                    aspectRatio = heightF / widthF
                }
                
                // MARK: Calculate image width, height
                let imageWidth = AppConstants.screenWidth - VideoCellConstants.cardViewOffset.left - VideoCellConstants.cardViewOffset.right - VideoCellConstants.videoImageInsets.left - VideoCellConstants.videoImageInsets.right
                
                let imageHeight = imageWidth * aspectRatio
                
                let imageYPos: CGFloat = VideoCellConstants.videoImageInsets.top
                
                let tableViewCellHeight: CGFloat = VideoCellConstants.cardViewOffset.top + VideoCellConstants.cardViewOffset.bottom + VideoCellConstants.videoImageInsets.top + imageHeight + VideoCellConstants.videoImageInsets.bottom
                
                var detailsString = "details string"
                var channelImageUrl = pair.channelInfo.snippet.thumbnails.medium.url
                
                let videoModel = VideoViewModel(videoId: pair.videoItem.id.videoId, thumbnailUrl: sizeInfo.url, channelImageUrl: channelImageUrl, videoNameString: pair.videoItem.snippet.description, detailsString: detailsString, imageFrame: CGRect(x: VideoCellConstants.videoImageInsets.left, y: imageYPos, width: imageWidth, height: imageHeight), tableViewCellHeight: tableViewCellHeight)
                
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
