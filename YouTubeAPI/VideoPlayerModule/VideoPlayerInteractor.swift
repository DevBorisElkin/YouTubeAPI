//
//  VideoPlayerInteractor.swift
//  YouTubeAPI
//
//  Created by test on 13.08.2022.
//

import Foundation

class VideoPlayerInteractor: VideoPlayerPresenterToInteractorProtocol {
    
    weak var presenter: VideoPlayerInteractorToPresenterProtocol?
    
    var videoModel: VideoViewModel?
    
    var lastCommentsResult: CommentsResultWrapped?
    
    func videoToShowRequested() {
        guard let videoModel = videoModel, let videoId = videoModel.videoId else { print("no video to show"); return }
        presenter?.videoToShowPrepared(videoModel: videoModel)
    }
    
    func commentsRequested(searchUrlString: String, appendComments: Bool, delay: Double) {
        Task.detached(priority: .medium) {
            // MARK: Artificial delay
            if delay > 0 {
                Thread.sleep(forTimeInterval: delay)
            }
            
            // MARK: LOAD COMMENTS
            let commentsData: CommentsResultWrapped?
            let resultCommentsData: Result<CommentsResultWrapped, Error>  = await NetworkingHelpers.loadDataFromUrlString(from: searchUrlString, printJsonAndRequestString: false)
            
            switch resultCommentsData {
            case .success(let data):
                commentsData = data
            case .failure(let error):
                print(error)
                self.presenter?.commentsLoadingFailed()
                return
            }
            guard let commentsData = commentsData else {
                print("search for comments failed");
                self.presenter?.commentsLoadingFailed()
                return }
            
            self.lastCommentsResult = commentsData
            self.presenter?.commentsReceived(commentsDataWrapped: commentsData, appendComments: appendComments)
        }
    }
    
    //func commentsRequestedForLastSearch() {
    //    guard let lastCommentsResult = lastCommentsResult else { print("no stored comments in interactor"); return }
    //    presenter?.commentsReceived(commentsDataWrapped: lastCommentsResult, appendToPreviousComments: false)
    //}
}
