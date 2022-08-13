//
//  VideoPlayerRouter.swift
//  YouTubeAPI
//
//  Created by test on 13.08.2022.
//

import Foundation
import UIKit

class VideoPlayerRouter: VideoPlayerPresenterToRouterProtocol {
    // todo check return type
    // todo resolve module dependencies
    static func createModule(with videoModel: VideoViewModel) -> UIViewController? {
        
        var presenter = VideoPlayerPresenter()
        var interactor = VideoPlayerInteractor()
        var router = VideoPlayerRouter()
        
        var videoPlayerViewController = VideoPlayerViewController()
        
        videoPlayerViewController.presenter = presenter
        
        // resolve dependencies
        videoPlayerViewController.presenter?.view = videoPlayerViewController
        videoPlayerViewController.presenter?.interactor = interactor
        videoPlayerViewController.presenter?.router = router
        
        videoPlayerViewController.presenter?.interactor?.presenter = presenter
        videoPlayerViewController.presenter?.interactor?.videoModel = videoModel
        
        return videoPlayerViewController
    }
}
