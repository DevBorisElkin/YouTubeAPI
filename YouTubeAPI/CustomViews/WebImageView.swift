import Foundation
import UIKit

class WebImageView: UIImageView {
    
    private var currentUrlString: String?
    
    func set(imageURL: String?, cacheAndRetrieveImage: Bool = true){
        
        currentUrlString = imageURL
        
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            print("couldn't convert url string to URL \(imageURL)")
            return }
        
        if cacheAndRetrieveImage, let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)){
            self.image = UIImage(data: cachedResponse.data)
            print("load image from cache \(imageURL)")
            return
        }
        
        print("load image from internet: \(imageURL)")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            DispatchQueue.main.async {
                if let data = data, let response = response, error == nil {
                    self?.handleLoadedImage(data: data, response: response, cacheAndRetrieveImage: cacheAndRetrieveImage )
                }else if let error = error {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse, cacheAndRetrieveImage: Bool = true){
        guard let responseUrl = response.url else{ return }
        
        if(cacheAndRetrieveImage){
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
        }
        
        if responseUrl.absoluteString == currentUrlString {
            self.image = UIImage(data: data)
        }
    }
}
