//
//  VideoSearchInteractor.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation

class VideoSearchInteractor: VideoSearchPresenterToInteractorProtocol {
    
    func performSearch(for search: String) {
        print("Performin request for string: \(search)")
        NetworkingHelpers.decodeDataWithResult(from: search, type: SearchResultWrapped.self, printJSON: true) { [weak self] result in
            self?.presenter?.receivedData(result: result)
        }
    }
    
    var presenter: VideoSearchInteractorToPresenterProtocol?
    
    
}
