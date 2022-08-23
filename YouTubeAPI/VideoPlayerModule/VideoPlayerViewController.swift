//
//  VideoPlayerViewController.swift
//  YouTubeAPI
//
//  Created by test on 13.08.2022.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: PannableViewController {
    
    var presenter: VideoPlayerViewIntoPresenterProtocol?
    var videoToShow: VideoToShow?
    
    private weak var holderSlidingView: HolderSlidingView?
    private weak var commentsView: CommentsView?
    
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
        return view
    }()
    
    lazy var commentsPreview: CommentsPreviewView = {
        let view = CommentsPreviewView()
        view.backgroundColor = .clear
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
    
    func enableShadow(){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 20
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
        
        holderView.addSubview(commentsPreview)
        commentsPreview.frame = CGRect(x: 0, y: channelInfoView.frame.maxY, width: AppConstants.screenWidth, height: VideoPlayerConstants.commentsViewHeight)
        commentsPreview.setUp(commentsCount: videoToShow.videoDetails.commentsCount, callback: onCommentsButtonPressed)
    }
    
    private func onCommentsButtonPressed() {
        print("onCommentsButtonPressed in VC")
        
        guard let videoToShow = videoToShow, let presenter = presenter else { print("No video to display comments for or no presenter"); return }

        createAndSetUpHolderSlidingView(videoToShow: videoToShow, presenter: presenter)
    }
    
    private func createAndSetUpHolderSlidingView(videoToShow: VideoToShow, presenter: VideoPlayerViewIntoPresenterProtocol){
        
        let topFadeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let bottomFadeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let holderSlidingSettings = HolderSlidingViewSettings(topFadeColor: topFadeColor, bottomFadeColor: bottomFadeColor, topFadeColorMaxAlpha: 0.7, bottomFadeColorMaxAlpha: 0.7)
        let slidingSettings = SlidingViewSettings(totalHeightWithSafeArea: view.frame.height, topAreaHeight: playerView.frame.height, safeAreaHeight: AppConstants.safeAreaPadding.top, slideInAnimationTime: 0.4, snapAnimationTime: 0.3)
        
        let holderSlidingView = HolderSlidingView()
        holderSlidingView.setUpWithMainSettings(parentView: view, holderSettings: holderSlidingSettings, slidingSettings: slidingSettings)
        holderSlidingView.setTopFadeViewDelegateClicks(to: playerView, hitTestOffset: CGPoint(x: 0, y: -AppConstants.safeAreaPadding.top))
        
        let commentsView = CommentsView()
        commentsView.initialSetUp(presenter: presenter)
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        holderSlidingView.setUpContents(contentView: commentsView)
        self.commentsView = commentsView
        self.holderSlidingView = holderSlidingView
        
        presenter.commentsRequested(videoId: videoToShow.videoId)
    }
}

extension VideoPlayerViewController: VideoPlayerPresenterToViewProtocol {
    
    func videoToShowDataReceived(videoToShow: VideoToShow) {
        self.videoToShow = videoToShow
        preparePlayer(videoToShow: videoToShow)
    }
    
    func onCommentsLoadingFailed(error: Error) {
        commentsView?.loadingDataEnded()
        commentsView?.refreshData()
        if let error = error as? NetworkingHelpers.NetworkRequestError, error == .youTubeQuotaExceeded {
            present(UIHelpers.createAlertController(title: AppConstants.ytQuotaExceededTitle, message: AppConstants.ytQuotaExceededMessage), animated: true)
        }
    }
    
    func commentsUpdated() {
        commentsView?.loadingDataEnded()
        commentsView?.refreshData()
    }
    
    func videoLoadingStarted() {
        commentsView?.loadingDataStarted()
    }
    
    func closeCommentsButtonPressed() {
        holderSlidingView?.close()
    }
}
