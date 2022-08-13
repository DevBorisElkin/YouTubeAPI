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
        
        view.addSubview(playerView)
        
        playerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        
        
        presenter?.viewDidLoad()
    }
    
    func videoToShowDataReceived(videoToShow: VideoToShow) {
        print("playerView.load")
        
        
        //playerView.frame = videoToShow.playerFrame
        
        //playerView.frame.size = videoToShow.playerFrame.size
        //playerView.frame.origin = CGPoint(x: videoToShow.playerFrame.minX,
        //                                  y: safeAreaTopView.frame.maxY + videoToShow.playerFrame.height)
        
//        playerView.frame.size = videoToShow.playerFrame.size
//        playerView.frame.origin = CGPoint(x: videoToShow.playerFrame.minX,
//                                          y: view.layoutMarginsGuide.layoutFrame.minY)
        
//        playerView.frame.size = videoToShow.playerFrame.size
//        playerView.frame.origin = CGPoint(x: videoToShow.playerFrame.minX,
//                                          y: view.layoutMarginsGuide.layoutFrame.origin.y)
//        print("view.layoutMarginsGuide.layoutFrame.minY: \(view.layoutMarginsGuide.layoutFrame.minY)")
//        print("view.layoutMarginsGuide.layoutFrame.origin.y: \(view.layoutMarginsGuide.layoutFrame.origin.y)")
        
        playerView.frame.size = videoToShow.playerFrame.size
        playerView.frame.origin = CGPoint(x: videoToShow.playerFrame.origin.x, y: playerView.frame.origin.y)
        playerView.load(withVideoId: videoToShow.videoId)
    }
}
