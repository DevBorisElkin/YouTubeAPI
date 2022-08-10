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
        var presenter = VideoSearchPresenter()
        var interactor = VideoSearchInteractor()
        var router = VideoSearchRouter()
        
        // create UI instances
        var viewController = VideoSearchViewController()
        
        // assign appropriate values
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        viewController.presenter = presenter
        
        router.entry = viewController
        
        return router
    }
}
