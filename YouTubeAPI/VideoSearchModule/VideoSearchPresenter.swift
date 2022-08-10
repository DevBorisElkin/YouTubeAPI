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
    var searchResults: [String] = ["Hello", "There"]
    
    func viewDidLoad() {
        
    }
    
    func refresh() {
        
    }
    
    func numberOfRowsInSection() -> Int {
        return searchResults.count
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: YouTubeVideoSearchCell.reuseId, for: indexPath) as! YouTubeVideoSearchCell
        return cell
    }
    
    func didSelectRowAt(index: Int) {
        // do nothing for now
    }
    
    func tableViewCellHeight() -> CGFloat {
        return VideoSearchConstants.tableViewCellHeight
    }
    
    // Logic related
    func performSearch(for search: String) {
        var preparedSearch: String = YouTubeHelper.getRequestString(for: search)
        interactor?.performSearch(for: preparedSearch)
    }
}

extension VideoSearchPresenter: VideoSearchInteractorToPresenterProtocol {

}
