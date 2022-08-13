//
//  VideoPlayerViewController.swift
//  YouTubeAPI
//
//  Created by test on 13.08.2022.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: UIViewController, VideoPlayerPresenterToViewProtocol {
    var presenter: VideoPlayerViewIntoPresenterProtocol?
    
    lazy var playerView: YTPlayerView = {
        var playerView = YTPlayerView()
        playerView.backgroundColor = .black
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        presenter?.viewDidLoad()
    }
    
    func videoToShowDataReceived(videoToShow: VideoToShow) {
        preparePlayer(playerHeight: videoToShow.playerFrame.height, videoId: videoToShow.videoId)
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
