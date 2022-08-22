
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
    
    func getRecommendedVideos()
    func performSearch(for search: String)
}

protocol VideoSearchVideoCellToPresenterProtocol: AnyObject {
    func requestedToOpenVideo(with viewModel: VideoViewModel)
}

protocol VideoSearchPresenterToViewProtocol: AnyObject  {
    var presenter: VideoSearchViewToPresenterProtocol? { get set }
    func onFetchVideosListSuccess()
    func onFetchVideosListFail()
    func showActivity() // ?
    func hideActivity() // ?
}

protocol VideoSearchPresenterToInteractorProtocol: AnyObject  {
    var presenter: VideoSearchInteractorToPresenterProtocol? { get set }
    
    func getRecommendedVideos()
    func performVideoSearch(for search: String)
}

protocol VideoSearchInteractorToPresenterProtocol: AnyObject  {
    func receivedData(result: Result<VideoIntermediateViewModel, Error>)
}

typealias EntryPoint = VideoSearchPresenterToViewProtocol & UIViewController

protocol VideoSearchPresenterToRouterProtocol: AnyObject  {
    var entry: EntryPoint? { get }
    
    static func start() -> VideoSearchPresenterToRouterProtocol
    
    func pushToVideoPlayer(on view: VideoSearchPresenterToViewProtocol?, with videoModel: VideoViewModel)
}
