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
    
    var holderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var playerView: YTPlayerView = {
        var playerView = YTPlayerView()
        playerView.backgroundColor = .black
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    lazy var videoNamelLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = VideoPlayerConstants.videoNameFontColor
        label.font = VideoPlayerConstants.videoNameFont
        return label
    }()
    
    lazy var videoDetailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = VideoPlayerConstants.videoDetailsFontColor
        label.font = VideoPlayerConstants.videoDetailsFont
        return label
    }()
    
    lazy var channelInfoView: ChannelInfoView = {
        let view = ChannelInfoView()
        view.backgroundColor = .white
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        preparePlayer(videoToShow: videoToShow)
    }
    
    private func preparePlayer(videoToShow: VideoToShow){
        
        // holder view
        view.addSubview(holderView)
        holderView.topAnchor.constraint(equalTo: view.topAnchor, constant: AppConstants.safeAreaPadding.top).isActive = true
        holderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        holderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        holderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Player view
        holderView.addSubview(playerView)
        playerView.topAnchor.constraint(equalTo: holderView.topAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: holderView.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: holderView.trailingAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: videoToShow.sizes.playerHeight).isActive = true
        
        playerView.load(withVideoId: videoToShow.videoId)
        
        // Video name label
        holderView.addSubview(videoNamelLabel)
        videoNamelLabel.frame = videoToShow.sizes.videoNameFrame
        videoNamelLabel.text = videoToShow.videoDetails.videoName
        
        // Video details label
        holderView.addSubview(videoDetailsLabel)
        videoDetailsLabel.frame = videoToShow.sizes.videoDetailsFrame
        videoDetailsLabel.text = videoToShow.videoDetails.videoDetailsViewsDatePrepared
        
        // Channel info view
        holderView.addSubview(channelInfoView)
        channelInfoView.frame = videoToShow.sizes.channelInfoFrame
        channelInfoView.setUp(viewModel: videoToShow.channelInfoViewModel)
    }
}
