
// All protocols for video search module
import Foundation
import UIKit

protocol VideoSearchViewToPresenterProtocol: AnyObject {
    var view: VideoSearchPresenterToViewProtocol? { get set }
    var interactor: VideoSearchPresenterToInteractorProtocol? { get set }
    var router: VideoSearchPresenterToRouterProtocol? { get set }
    
    // vc lifecycle related
    func viewDidLoad()
    
    // table view related
    func canScrollProgrammatically() -> Bool
    func numberOfRowsInSection() -> Int
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat
    
    // videos request
    func refresh()
    func getVideos(requestDetails: VideosRequestType)
    func videosPaginationRequest()
}

protocol VideoSearchVideoCellToPresenterProtocol: AnyObject {
    func requestedToOpenVideo(with viewModel: VideoViewModel)
}

protocol VideoSearchPresenterToViewProtocol: AnyObject  {
    var presenter: VideoSearchViewToPresenterProtocol? { get set }
    func onFetchVideosListStarted()
    func onFetchVideosListSuccess()
    func onFetchVideosListFail(error: Error)
}

protocol VideoSearchPresenterToInteractorProtocol: AnyObject  {
    var presenter: VideoSearchInteractorToPresenterProtocol? { get set }
    
    func performVideosSearch(requestType: VideosRequestType)
}

protocol VideoSearchInteractorToPresenterProtocol: AnyObject  {
    func receivedData(result: VideoIntermediateViewModel, requestPurpose: VideosRequestType.RequestPurpose, nextPageToken: String?)
    func onVideosLoadingFailed(error: Error)
}

typealias EntryPoint = VideoSearchPresenterToViewProtocol & UIViewController

protocol VideoSearchPresenterToRouterProtocol: AnyObject  {
    var entry: EntryPoint? { get }
    
    static func start() -> VideoSearchPresenterToRouterProtocol
    
    func pushToVideoPlayer(on view: VideoSearchPresenterToViewProtocol?, with videoModel: VideoViewModel)
}
