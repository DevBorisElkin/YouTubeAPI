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
    
    func videoToShowRequested() {
        guard let videoModel = videoModel, let videoId = videoModel.videoId else { print("no video to show"); return }
        presenter?.videoToShowPrepared(videoModel: videoModel)
    }
    
    func commentsRequested(searchUrlString: String) {
        Task.detached(priority: .medium) {
            // MARK: LOAD COMMENTS
            let commentsData: CommentsResultWrapped?
            let resultCommentsData: Result<CommentsResultWrapped, Error>  = await NetworkingHelpers.loadDataFromUrlString(from: searchUrlString, printJsonAndRequestString: true)
            
            switch resultCommentsData {
            case .success(let data):
                commentsData = data
            case .failure(let error):
                print(error)
                return
            }
            guard let commentsData = commentsData else { print("search for comments failed"); return }
            
            self.presenter?.commentsReceived(commentsDataWrapped: commentsData)
        }
    }
}
