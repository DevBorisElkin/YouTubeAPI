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
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        return alert
    }
}
