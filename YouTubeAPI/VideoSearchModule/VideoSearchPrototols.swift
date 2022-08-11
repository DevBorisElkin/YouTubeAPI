
// All protocols for video search module
import Foundation
import UIKit

protocol VideoSearchViewToPresenterProtocol {
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
    
    func performSearch(for search: String)
}

protocol VideoSearchPresenterToViewProtocol {
    var presenter: VideoSearchViewToPresenterProtocol? { get set }
    func onFetchVideosListSuccess()
    func onFetchVideosListFail()
    func showActivity() // ?
    func hideActivity() // ?
}

protocol VideoSearchPresenterToInteractorProtocol {
    var presenter: VideoSearchInteractorToPresenterProtocol? { get set }
    
    func performSearch(for search: String)
}

protocol VideoSearchInteractorToPresenterProtocol {
    func receivedData(result: Result<VideoIntermediateViewModel, Error>)
}

typealias EntryPoint = VideoSearchPresenterToViewProtocol & UIViewController

protocol VideoSearchPresenterToRouterProtocol {
    var entry: EntryPoint? { get }
    
    static func start() -> VideoSearchPresenterToRouterProtocol
}
