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
                
                let channelImageUrl = pair.channelInfo.snippet.thumbnails.def.url.replacingOccurrences(of: "https", with: "http")
                
                // MARK: Calculate videoName frame
                
                var videoNameRect = CGRect(origin: CGPoint(
                    x: VideoCellConstants.channelIconInsets.left + VideoCellConstants.channelIconSize + VideoCellConstants.videoNameInsets.left,
                    y: VideoCellConstants.videoImageInsets.top + imageHeight + VideoCellConstants.videoNameInsets.top), size: CGSize.zero)
                
                var videoNameWidth: CGFloat = AppConstants.screenWidth - VideoCellConstants.cardViewOffset.left - VideoCellConstants.cardViewOffset.right - VideoCellConstants.channelIconInsets.left - VideoCellConstants.channelIconSize - VideoCellConstants.videoNameInsets.left - VideoCellConstants.videoNameInsets.right
                
                var videoNameText = pair.videoItem.snippet.description
                
                if !videoNameText.isEmpty {
                    var height = videoNameText.height(width: videoNameWidth, font: VideoCellConstants.videoNameFont)
                    
                    // check limit height for name label
                    let limitHeight = VideoCellConstants.videoNameFont.lineHeight * VideoCellConstants.videoNameFontMaxLines
                    
                    if height > limitHeight {
                        height = VideoCellConstants.videoNameFont.lineHeight * VideoCellConstants.videoNameFontMaxLines
                    }
                    
                    videoNameRect.size = CGSize(width: videoNameWidth, height: height)
                }
                
                // MARK: Calculate videoDetails frame
                var videoDetailsRect = CGRect(origin: CGPoint(
                    x: VideoCellConstants.channelIconInsets.left + VideoCellConstants.channelIconSize + VideoCellConstants.videoDetailsInsets.left,
                    y: videoNameRect.maxY + VideoCellConstants.videoDetailsInsets.top), size: CGSize.zero)
                
                var videoDetailsWidth: CGFloat = AppConstants.screenWidth - VideoCellConstants.cardViewOffset.left - VideoCellConstants.cardViewOffset.right - VideoCellConstants.channelIconInsets.left - VideoCellConstants.channelIconSize - VideoCellConstants.videoNameInsets.left - VideoCellConstants.videoNameInsets.right
                
                var dateString = DateHelpers.getTimeSincePublication(from: pair.videoItem.snippet.publishTime)
                print("DateString: \(pair.videoItem.snippet.publishTime)")
                print("Converted to result: \(dateString)")
                
                var detailsString = "\(pair.videoItem.snippet.channelTitle) ◦ \(dateString)"
                
                
                if !detailsString.isEmpty {
                    var height = detailsString.height(width: videoDetailsWidth, font: VideoCellConstants.videoDetailsFont)
                    
                    // check limit height for details label
                    let limitHeight = VideoCellConstants.videoDetailsFont.lineHeight * VideoCellConstants.videoDetailsFontMaxLines
                    
                    if height > limitHeight {
                        height = VideoCellConstants.videoDetailsFont.lineHeight * VideoCellConstants.videoDetailsFontMaxLines
                    }
                    
                    videoDetailsRect.size = CGSize(width: videoNameWidth, height: height)
                }
                
                // MARK: TableView cell height
//                let tableViewCellHeight: CGFloat = VideoCellConstants.cardViewOffset.top + VideoCellConstants.cardViewOffset.bottom + VideoCellConstants.videoImageInsets.top + imageHeight + VideoCellConstants.videoImageInsets.bottom + VideoCellConstants.channelIconSize + VideoCellConstants.channelIconInsets.top + VideoCellConstants.channelIconInsets.bottom
                let tableViewCellHeight: CGFloat = videoDetailsRect.maxY + VideoCellConstants.videoDetailsInsets.bottom + VideoCellConstants.cardViewOffset.top + VideoCellConstants.cardViewOffset.bottom
                
                let videoModel = VideoViewModel(videoId: pair.videoItem.id.videoId, thumbnailUrl: sizeInfo.url, channelImageUrl: channelImageUrl, videoNameString: pair.videoItem.snippet.description, detailsString: detailsString, imageFrame: CGRect(x: VideoCellConstants.videoImageInsets.left, y: imageYPos, width: imageWidth, height: imageHeight), tableViewCellHeight: tableViewCellHeight, videoNameFrame: videoNameRect, videoDetailsFrame: videoDetailsRect)
                
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
