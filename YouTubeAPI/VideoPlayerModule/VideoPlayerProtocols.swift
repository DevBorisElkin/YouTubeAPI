//
//  VideoPlayerProtocols.swift
//  YouTubeAPI
//
//  Created by test on 13.08.2022.
//

import Foundation
import UIKit

protocol VideoPlayerViewIntoPresenterProtocol: AnyObject  {
    var view: VideoPlayerPresenterToViewProtocol? { get set }
    var interactor: VideoPlayerPresenterToInteractorProtocol? { get set }
    var router: VideoPlayerPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func commentsRequested
}

protocol VideoPlayerPresenterToViewProtocol: AnyObject {
    var presenter: VideoPlayerViewIntoPresenterProtocol? { get set }
    
    func videoToShowDataReceived(videoToShow: VideoToShow)
}

protocol VideoPlayerPresenterToInteractorProtocol: AnyObject  {
    var presenter: VideoPlayerInteractorToPresenterProtocol? { get set }
    var videoModel: VideoViewModel? { get set }
    
    func videoToShowRequested()
}

protocol VideoPlayerInteractorToPresenterProtocol: AnyObject  {
    func videoToShowPrepared(videoModel: VideoViewModel)
}

protocol VideoPlayerPresenterToRouterProtocol: AnyObject  {
    static func createModule(with videoModel: VideoViewModel) -> UIViewController?
}
