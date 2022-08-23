import UIKit

class UIHelpers{
    
    /// for example, frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
    public static func createSpinnerFooter(frame: CGRect) -> UIView{
        let footerView = UIView(frame: frame)
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        
        spinner.startAnimating()
        return footerView
    }
    
    public static func createSpinnerFooterWithConstraints(frame: CGRect) -> UIView{
        let footerView = UIView(frame: frame)
        
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        spinner.startAnimating()
        return footerView
    }
    
    static func createYouTubeQuotaExceededController() -> UIAlertController {
        let alert = UIAlertController(title: "YouTube API quota exceeded", message: "YouTube limits it's API usage by a quota, gives each 'user' 10000 so called 'points'. Search request costs 100 points, so, daily quota is enough for 100 search requests. Unfortunately, quota for API key, generated for this app exceeded. It will 'regenerate' eventually, try again later.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        return alert
    }
}
