


import Foundation
import UIKit

class CommentsPreviewView: UIView {
    
    var callback: (() -> Void)?
    
    lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = VideoPlayerConstants.commentsLabelFontColor
        label.font = VideoPlayerConstants.commentsLabelFont
        label.backgroundColor = .clear
        label.text = "Comments"
        return label
    }()
    
    lazy var commentsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = VideoPlayerConstants.commentsCountLabelFontColor
        label.font = VideoPlayerConstants.commentsCountLabelFont
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var expandCommentsButton: ExpandedButton = {
        let button = ExpandedButton()
        button.clickIncreasedArea = AppConstants.expandCustomButtonsClickArea
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("show comments", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = VideoPlayerConstants.expandCommentsButtonFont
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints(){
        // commentsLabel
        addSubview(commentsLabel)
        
        commentsLabel.topAnchor.constraint(equalTo: topAnchor, constant: VideoPlayerConstants.commentsLabelInsets.top).isActive = true
        commentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: VideoPlayerConstants.commentsLabelInsets.left).isActive = true
        
        // commentsCountLabel
        addSubview(commentsCountLabel)

        commentsCountLabel.centerYAnchor.constraint(equalTo: commentsLabel.centerYAnchor).isActive = true
        commentsCountLabel.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: VideoPlayerConstants.commentsCountLabelInsets.left).isActive = true

        // expandCommentsButton
        addSubview(expandCommentsButton)
        expandCommentsButton.centerYAnchor.constraint(equalTo: commentsCountLabel.centerYAnchor).isActive = true
        expandCommentsButton.leadingAnchor.constraint(equalTo: commentsCountLabel.trailingAnchor, constant: VideoPlayerConstants.expandCommentsButtonInsets.left).isActive = true
        expandCommentsButton.heightAnchor.constraint(equalToConstant: VideoPlayerConstants.expandCommentsButtonSize.height).isActive = true
    }
    
    func setUp(commentsCount: String, callback: @escaping () -> Void){
        self.callback = callback
        commentsCountLabel.text = commentsCount
        expandCommentsButton.addTarget(self, action: #selector(expandCommentsPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func expandCommentsPressed(_ sender: Any){
        print("expandCommentsPressed")
        callback?()
    }
}
