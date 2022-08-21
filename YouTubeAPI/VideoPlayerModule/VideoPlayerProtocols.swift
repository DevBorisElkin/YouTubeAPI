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
    
    // MARK: Methods to request comments
    func commentsRequested(videoId: String) // fresh request for comments
    func commentsRequestedToGetUpdated()
    func commentsPaginationRequest()
    func expandTextForComment(commentId: String) // add comment id to expanded comments and returns last request recorded data (no need to request data again)
    
    // MARK: For comments table view
    func numberOfRowsInSection() -> Int
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func didSelectRowAt(index: Int)
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat
    
    func closeCommentsButtonpPressed()
}

protocol VideoPlayerPresenterToViewProtocol: AnyObject {
    var presenter: VideoPlayerViewIntoPresenterProtocol? { get set }
    
    func videoToShowDataReceived(videoToShow: VideoToShow)
    func commentsUpdated()
    
    // for footer view
    func videoLoadingStarted()
    func closeCommentsButtonPressed()
}

protocol VideoPlayerPresenterToInteractorProtocol: AnyObject  {
    var presenter: VideoPlayerInteractorToPresenterProtocol? { get set }
    var videoModel: VideoViewModel? { get set }
    
    func videoToShowRequested()
    func commentsRequested(searchUrlString: String, delay: Double)
}

protocol VideoPlayerInteractorToPresenterProtocol: AnyObject  {
    func videoToShowPrepared(videoModel: VideoViewModel)
    func commentsReceived(commentsDataWrapped: CommentsResultWrapped)
}

protocol VideoPlayerPresenterToRouterProtocol: AnyObject  {
    static func createModule(with videoModel: VideoViewModel) -> UIViewController?
}
