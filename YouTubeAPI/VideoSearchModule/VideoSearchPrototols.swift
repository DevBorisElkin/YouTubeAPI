
// All protocols for video search module
import Foundation
import UIKit

protocol VideoSearchViewToPresenterProtocol: AnyObject {
    var view: VideoSearchPresenterToViewProtocol? { get set }
    var interactor: VideoSearchPresenterToInteractorProtocol? { get set }
    var router: VideoSearchPresenterToRouterProtocol? { get set }
    
    // vc lifecycle related
    func viewDidLoad()
    func refresh() // ?
    
    // table view related
    func numberOfRowsInSection() -> Int
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func didSelectRowAt(index: Int) // ?
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat
    
    // videos request
    func getVideos(requestDetails: VideosRequestType)
}

protocol VideoSearchVideoCellToPresenterProtocol: AnyObject {
    func requestedToOpenVideo(with viewModel: VideoViewModel)
}

protocol VideoSearchPresenterToViewProtocol: AnyObject  {
    var presenter: VideoSearchViewToPresenterProtocol? { get set }
    func onFetchVideosListStarted()
    func onFetchVideosListSuccess()
    func onFetchVideosListFail()
}

protocol VideoSearchPresenterToInteractorProtocol: AnyObject  {
    var presenter: VideoSearchInteractorToPresenterProtocol? { get set }
    
    func performVideosSearch(requestType: VideosRequestType)
}

protocol VideoSearchInteractorToPresenterProtocol: AnyObject  {
    func receivedData(result: Result<VideoIntermediateViewModel, Error>, requestPurpose: VideosRequestType.RequestPurpose)
    func onVideosLoadingFailed()
}

typealias EntryPoint = VideoSearchPresenterToViewProtocol & UIViewController

protocol VideoSearchPresenterToRouterProtocol: AnyObject  {
    var entry: EntryPoint? { get }
    
    static func start() -> VideoSearchPresenterToRouterProtocol
    
    func pushToVideoPlayer(on view: VideoSearchPresenterToViewProtocol?, with videoModel: VideoViewModel)
}
