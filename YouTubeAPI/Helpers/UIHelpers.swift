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
}
