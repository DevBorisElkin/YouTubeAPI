//
//  VideoSearchRouter.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation
import UIKit

class VideoSearchRouter: VideoSearchPresenterToRouterProtocol {
    var entry: EntryPoint?
    
    static func start() -> VideoSearchPresenterToRouterProtocol {
        // create instances
        let presenter = VideoSearchPresenter()
        let interactor = VideoSearchInteractor()
        let router = VideoSearchRouter()
        
        // create UI instances
        let viewController = VideoSearchViewController()
        
        // assign appropriate values
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        viewController.presenter = presenter
        
        router.entry = viewController
        
        return router
    }
    
    func pushToVideoPlayer(on view: VideoSearchPresenterToViewProtocol?, with videoModel: VideoViewModel) {
        if let videoPlayerViewController = VideoPlayerRouter.createModule(with: videoModel) as? VideoPlayerViewController, let viewController = view as? VideoSearchViewController {
            
            videoPlayerViewController.modalPresentationStyle = .overCurrentContext
            viewController.present(videoPlayerViewController, animated: true, completion: videoPlayerViewController.enableShadow)
        }
    }
}
