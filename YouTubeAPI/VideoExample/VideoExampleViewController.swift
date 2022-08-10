//
//  ViewController.swift
//  YouTubeAPI
//
//  Created by test on 09.08.2022.
//

import UIKit
import youtube_ios_player_helper

class VideoExampleViewController: UIViewController, YTPlayerViewDelegate {

    lazy var playerView: YTPlayerView = {
        var playerView = YTPlayerView()
        playerView.backgroundColor = .black
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    var button: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitle("Press Me", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        additionalSetUp()
    }
    
    func setUpConstraints(){
        view.addSubview(playerView)
        playerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.6).isActive = true
        playerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        view.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 50).isActive = true
        button.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
    }
    
    func additionalSetUp(){
        playerView.load(withVideoId: "bsM1qdGAVbU")
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print(#function)
        //playerView.playVideo()
        
    }
    
    @objc func buttonPressed(_ sender: Any){
        print("button pressed")
        
        playerView.playerState { [weak self] state, error in
            switch state {
                
            case .unstarted:
                print("1")
            case .ended:
                print("2")
            case .playing:
                print("3")
            case .paused:
                print("4")
            case .buffering:
                print("5")
            case .cued:
                print("6")
            case .unknown:
                print("7")
            @unknown default:
                print("8")
            }
            
            self?.playOrPauseDependingOnState(state: state)
            
            
        }
    }
    
    func playOrPauseDependingOnState(state: YTPlayerState)
    {
        if state == .cued || state == .paused {
            playerView.playVideo()
        }else if(state == .playing){
            playerView.pauseVideo()
        }
    }

}

