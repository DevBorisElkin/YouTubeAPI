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
    
    func viewDidLoad() {
        interactor?.videoToShowRequested()
    }
}

extension VideoPlayerPresenter : VideoPlayerInteractorToPresenterProtocol {
    func videoToShowPrepared(videoModel: VideoViewModel) {
        // calculate sizes
        var frame = YouTubeVideoSearchCellLayoutCalculator.calculateVideoPlayerFrame(thumbnailSize: videoModel.sizes.imageFrame.size)
        let videoToShow = VideoToShow(videoId: videoModel.videoId!,
                                      playerFrame: frame)
        view?.videoToShowDataReceived(videoToShow: videoToShow)
    }
}
