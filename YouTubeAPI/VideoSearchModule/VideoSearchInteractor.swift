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
        NetworkingHelpers.decodeDataWithResult(from: search, type: SearchResultWrapped.self, printJSON: true) { result in
            switch result {
                
            case .success(let data):
                print("Success retrieving data")
            case .failure(let error):
                print("Error retrieving data \(error)")
            }
        }
    }
    
    var presenter: VideoSearchInteractorToPresenterProtocol?
    
    
}
