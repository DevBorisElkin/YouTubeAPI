//
//  CommentTableViewCell.swift
//  YouTubeAPI
//
//  Created by test on 20.08.2022.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    weak var presenter: VideoPlayerViewIntoPresenterProtocol?
    static let reuseId = "CommentTableViewCell"
    private var viewModel: CommentViewModel!
    
    lazy var commentTopLineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = CommentCellConstants.commentTopLineFontColor
        label.font = CommentCellConstants.commentTopLineFont
        label.backgroundColor = .brown
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(viewModel: CommentViewModel){
        self.viewModel = viewModel
        print("setUp -> comment cell")
        
        addSubview(commentTopLineLabel)
        commentTopLineLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: CommentCellConstants.commentTopLineInsets)
        
        commentTopLineLabel.text = viewModel.userDateEditedCombinedString
    }

}
