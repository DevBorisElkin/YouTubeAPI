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
    var videoIdForComments: String?
    var nextPageToken: String?
    
    func viewDidLoad() {
        interactor?.videoToShowRequested()
    }
    
    // MARK: Methods to request comments
    func commentsRequested(videoId: String) {
        videoIdForComments = videoId
        // request comments if they haven't been loaded for this video
        if commentSearchResults.isEmpty {
            print("Comments are empty, delegating loading process to interactor")
            view?.videoLoadingStarted()
            interactor?.commentsRequested(searchUrlString: YouTubeHelper.getCommentsForVideoRequestString(forVideoId: videoId), appendComments: true, delay: AppConstants.commentRequestArtificialDelay)
        }else{
            print("Presenter will not delegate loading process of comments to interactor because comments are already loaded for this video")
        }
    }
    
    // make a request, but before check if id of video is available
    func commentsRequestedToGetUpdated() {
        guard let videoId = videoIdForComments else {
            print("No video to load comments for"); return
        }
        // show loading
        interactor?.commentsRequested(searchUrlString: YouTubeHelper.getCommentsForVideoRequestString(forVideoId: videoId), appendComments: false, delay: AppConstants.commentRequestArtificialDelay)
    }
    
    func expandTextForComment(commentId: String) {
        if !expandedCommentsIds.contains(commentId) {
            expandedCommentsIds.append(commentId)
            
            let commentIndex: Int? = commentSearchResults.firstIndex { $0.commentId == commentId }
            guard let commentIndex = commentIndex else { print("Didn't find comment by id \(commentId)"); return }
            
            var commentItem = commentSearchResults[commentIndex]
            
            commentItem.sizes = YouTubeCommentCellLayoutCalculator.calculateCommentCellSizes(topDescriptionText: commentItem.userDateEditedCombinedString, commentText: commentItem.commentText, isFullSizedPost: true)
            
            commentSearchResults[commentIndex] = commentItem
            
            self.view?.commentsUpdated()
        } else { print("Can't expand comments for video which comments had already been expanded") }
    }
    
    func commentsPaginationRequest() {
        guard let nextPageToken = nextPageToken, let lastVideoIdRequested = videoIdForComments else {
            print("No next page token, or lastVideoIdRequested, nothing to load, returning")
            return
        }
        view?.videoLoadingStarted()
        let requestString = YouTubeHelper.getCommentsForVideoRequestString(forVideoId: lastVideoIdRequested, forPageToken: nextPageToken)
        interactor?.commentsRequested(searchUrlString: requestString, appendComments: true, delay: AppConstants.commentRequestArtificialDelay)
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
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        return commentSearchResults[indexPath.row].sizes.tableViewCellHeight
    }
    
    // for close button pressed
    func closeCommentsButtonpPressed() {
        view?.closeCommentsButtonPressed()
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
    
    func commentsLoadingFailed() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.commentsUpdated()
        }
    }
    
    // TODO: you need to store nextPage string to make further requests for more data
    func commentsReceived(commentsDataWrapped: CommentsResultWrapped, appendComments: Bool) {
        // todo convert data from CommentsesultWrapped to commentSearchResults[ViewModel]
        print("Presenter, comments received")
        
        let commentItems: [CommentItem] = commentsDataWrapped.items ?? []
            
        let commentsRemapped: [CommentViewModel] = commentItems.map { self.prepareComment(commentItem: $0) }
        
        DispatchQueue.main.async {
            self.nextPageToken = commentsDataWrapped.nextPageToken
            
            if(appendComments){
                self.commentSearchResults.append(contentsOf: commentsRemapped)
            }else{
                self.commentSearchResults = commentsRemapped
            }
            
            self.view?.commentsUpdated()
        }
    }
    
    private func prepareComment(commentItem: CommentItem) -> CommentViewModel {
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
}
