//
//  VideoSearchPresenter.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation
import UIKit

class VideoSearchPresenter: VideoSearchViewToPresenterProtocol {
    var view: VideoSearchPresenterToViewProtocol?
    var interactor: VideoSearchPresenterToInteractorProtocol?
    var router: VideoSearchPresenterToRouterProtocol?
    
    // TODO fill real data
    var searchResults: [VideoViewModel] = []
    
    func viewDidLoad() {
        
    }
    
    func refresh() {
        
    }
    
    // MARK: For table view
    func numberOfRowsInSection() -> Int {
        return searchResults.count
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: YouTubeVideoSearchCell.reuseId, for: indexPath) as! YouTubeVideoSearchCell
        cell.setUp(viewModel: searchResults[indexPath.row])
        return cell
    }
    
    func didSelectRowAt(index: Int) {
        // do nothing for now
    }
    
    func tableViewCellHeight() -> CGFloat {
        return VideoSearchConstants.tableViewCellHeight
    }
    
    // MARK: Logic related
    func performSearch(for search: String) {
        var finalSearchString = search
        if finalSearchString.contains(" "){
            guard let searchWithSpaces = finalSearchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Couldn't replace spaces")
                return
            }
            finalSearchString = searchWithSpaces
        }
        var preparedSearch: String = YouTubeHelper.getRequestString(for: finalSearchString)
        interactor?.performSearch(for: preparedSearch)
    }
}

extension VideoSearchPresenter: VideoSearchInteractorToPresenterProtocol {
    func receivedData(result: Result<SearchResultWrapped, Error>) {
        
        switch result {
        case .success(let data):
            print("Successfully received data")
            
            searchResults = data.items.map({ item in
                VideoViewModel(videoId: item.id.videoId, videoName: item.snippet.description)
            })
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.onFetchVideosListSuccess()
            }
            
            
        case .failure(let error):
            print("Error receiving data: \(error)")
        }
        
    }
    
    
}
