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
}
