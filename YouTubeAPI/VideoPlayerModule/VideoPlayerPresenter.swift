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
    var expandedCommentsIds: [String] = []
    var nextPageToken: String?
    
    func viewDidLoad() {
        interactor?.videoToShowRequested()
    }
    
    // MARK: Methods to request comments
    func commentsRequested(videoId: String) {
        // request comments if they haven't been loaded for this video
        if commentSearchResults.isEmpty {
            print("Comments are empty, delegating loading process to interactor")
            interactor?.commentsRequested(searchUrlString: YouTubeHelper.getCommentsForVideoRequestString(forVideoId: videoId), appendToPreviousComments: true)
        }else{
            print("Presenter will not delegate loading process of comments to interactor because comments are already loaded for this video")
        }
    }
    func commentsRequestedToGetUpdated() {
        // todo just update comments without a network request
    }
    
    func expandTextForComment(commentId: String) {
        if !expandedCommentsIds.contains(commentId) {
            expandedCommentsIds.append(commentId)
            
            interactor?.commentsRequestedForLastSearch() // won't append comments
        } else { print("Can't expand comments for video which comments had already been expanded") }
    }
    
    func moreCommentsRequestedForLastCommentsResult() {
        // todo
    }
    
    // MARK: For table view
    func numberOfRowsInSection() -> Int {
        return commentSearchResults.count
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.reuseId, for: indexPath) as! CommentTableViewCell
        cell.setUp(viewModel: commentSearchResults[indexPath.row], presenter: self)
        return cell
    }
    
    func didSelectRowAt(index: Int) {
        // do nothing for now
    }
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        return commentSearchResults[indexPath.row].sizes.tableViewCellHeight
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
    func commentsReceived(commentsDataWrapped: CommentsResultWrapped, appendToPreviousComments: Bool) {
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
            
            let expandedComment: Bool = expandedCommentsIds.contains(commentItem.id)
            //var expandedComment = true
            
            let sizes = YouTubeCommentCellLayoutCalculator.calculateCommentCellSizes(topDescriptionText: topString, commentText: commentItem.snippet.topLevelComment.snippet.textDisplay, isFullSizedPost: expandedComment)
            
            let userIconUrlString = AppConstants.preferHttpForStaticContent ? commentItem.snippet.topLevelComment.snippet.authorProfileImageUrl.replacingOccurrences(of: "https", with: "http") : commentItem.snippet.topLevelComment.snippet.authorProfileImageUrl
            
            return CommentViewModel(commentId: commentItem.id, userDateEditedCombinedString: topString,
                             commentText: commentItem.snippet.topLevelComment.snippet.textDisplay,
                                    authorProfileImageUrl: userIconUrlString,
                             likeCount: String(commentItem.snippet.topLevelComment.snippet.likeCount),
                             totalReplyCount: String(commentItem.snippet.totalReplyCount),
                             sizes: sizes)
        }
        DispatchQueue.main.async {
            if !appendToPreviousComments {
                // we don't append comments only for expanding comment cells
                self.commentSearchResults = commentsRemapped
            }else{
                // recorn token, we use append when we make first request or other appending requests
                self.nextPageToken = commentsDataWrapped.nextPageToken
                self.commentSearchResults.append(contentsOf: commentsRemapped)
            }
            
            // maybe not to return comments to the view, only to notify it
            self.view?.commentsUpdated()
        }
    }
}
