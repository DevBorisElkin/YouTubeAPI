//
//  VideoPlayerViewController.swift
//  YouTubeAPI
//
//  Created by test on 13.08.2022.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: PannableViewController, VideoPlayerPresenterToViewProtocol {
    var presenter: VideoPlayerViewIntoPresenterProtocol?
    
    var playerView: YTPlayerView = {
        var playerView = YTPlayerView()
        playerView.backgroundColor = .black
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAnimationValues(panPercentageToDismiss: 0.2,
                                  minVelocityToDismiss: nil,
                                  scaleSetting: ScaleSetting(scaleStrength: CGPoint(x: 0.2, y: 0.2), targetPanPercentageForMaxResult: CGPoint(x: 0.15, y: 0.15)),
                                  cornerRadiusSetting: CornerRadiusSetting(maxCornerRadius: 15, panPercentageForMaxResult: 0.15))
        view.backgroundColor = .white
        presenter?.viewDidLoad()
    }
    
    func videoToShowDataReceived(videoToShow: VideoToShow) {
        preparePlayer(playerHeight: videoToShow.playerHeight, videoId: videoToShow.videoId)
    }
    
    private func preparePlayer(playerHeight: CGFloat, videoId: String){
        view.addSubview(playerView)
        playerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: playerHeight).isActive = true
        
        playerView.load(withVideoId: videoId)
    }
}
