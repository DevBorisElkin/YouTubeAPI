//
//  VideoPlayerPresenter.swift
//  YouTubeAPI
//
//  Created by test on 13.08.2022.
//

import Foundation
import UIKit

class VideoPlayerPresenter: VideoPlayerViewIntoPresenterProtocol {
    
    weak var view: VideoPlayerPresenterToViewProtocol?
    var interactor: VideoPlayerPresenterToInteractorProtocol?
    var router: VideoPlayerPresenterToRouterProtocol?
    
    var commentSearchResults: [CommentViewModel] = []
    
    func viewDidLoad() {
        interactor?.videoToShowRequested()
    }
    
    func commentsRequested(videoId: String) {
        // request comments if they haven't been loaded for this video
        if commentSearchResults.isEmpty {
            print("Comments are empty, delegating loading process to interactor")
            interactor?.commentsRequested(searchUrlString: YouTubeHelper.getCommentsForVideoRequestString(forVideoId: videoId))
        }else{
            print("Presenter will not delegate loading process of comments to interactor because comments are already loaded for this video")
        }
    }
    
    // MARK: For table view
    func numberOfRowsInSection() -> Int {
        return commentSearchResults.count
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.reuseId, for: indexPath) as! CommentTableViewCell
        cell.presenter = self
        cell.setUp(viewModel: commentSearchResults[indexPath.row])
        return cell
    }
    
    func didSelectRowAt(index: Int) {
        // do nothing for now
    }
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        return commentSearchResults[indexPath.row].sizes.tableViewCellFullHeight
    }
}

extension VideoPlayerPresenter : VideoPlayerInteractorToPresenterProtocol {
    
    func videoToShowPrepared(videoModel: VideoViewModel) {
        
        // MARK: calculate sizes
        let sizes = YouTubeVideoCellLayoutCalculator.calculateVideoCellSizes(
            thumbnailSize: videoModel.sizes.imageFrame.size,
            videoDetails: videoModel.videoDetails)
        
        let videoToShow = VideoToShow(videoId: videoModel.videoId!,
                                      videoDetails: videoModel.videoDetails,
                                      channelInfoViewModel: ChannelInfoViewModel(channelName: videoModel.videoDetails.channelName, subscribersCount: videoModel.videoDetails.channelSubscribersCount, channelIconUrlString: videoModel.channelImageUrl!),
                                      sizes: sizes)
        
        view?.videoToShowDataReceived(videoToShow: videoToShow)
    }
    
    // TODO: you need to store nextPage string to make further requests for more data
    func commentsReceived(commentsDataWrapped: CommentsResultWrapped) {
        // todo convert data from CommentsesultWrapped to commentSearchResults[ViewModel]
        
        guard let commentItems = commentsDataWrapped.items else {
            print("Presenter received no comments for request, returning")
            return
        }
        let commentsRemapped: [CommentViewModel] = commentItems.map { commentItem in
            
            let dateString = DateHelpers.getTimeSincePublication(from: commentItem.snippet.topLevelComment.snippet.publishedAt)
            let isTextEditedString = commentItem.snippet.topLevelComment.snippet.textOriginal != commentItem.snippet.topLevelComment.snippet.textDisplay ? " (edited)" : ""
            
            let topString = "\(commentItem.snippet.topLevelComment.snippet.authorDisplayName) ◦ \(dateString) \(isTextEditedString)"
            
            // TODO: calculate proper sizes
            // Sizes:
            let sizes = YouTubeCommentCellLayoutCalculator.calculateCommentCellSizes(topDescriptionText: topString, commentText: commentItem.snippet.topLevelComment.snippet.textDisplay)
            
            return CommentViewModel(userDateEditedCombinedString: topString,
                             commentText: commentItem.snippet.topLevelComment.snippet.textDisplay,
                             authorProfileImageUrl: commentItem.snippet.topLevelComment.snippet.authorProfileImageUrl,
                             likeCount: String(commentItem.snippet.topLevelComment.snippet.likeCount),
                             totalReplyCount: String(commentItem.snippet.totalReplyCount),
                             sizes: sizes)
        }
        DispatchQueue.main.async {
            self.commentSearchResults = commentsRemapped
            // maybe not to return comments to the view, only to notify it
            self.view?.commentsReceived(comments: commentsRemapped)
        }
    }
}
