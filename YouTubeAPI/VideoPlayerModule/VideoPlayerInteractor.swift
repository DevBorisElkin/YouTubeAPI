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
}
