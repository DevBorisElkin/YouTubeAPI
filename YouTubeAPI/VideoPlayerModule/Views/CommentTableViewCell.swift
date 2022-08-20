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
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = CommentCellConstants.commentTopLineFont
        label.textColor = CommentCellConstants.commentTopLineFontColor
        label.backgroundColor = .brown
        return label
    }()
    
    lazy var commentTextLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = CommentCellConstants.commentTextFont
        label.textColor = CommentCellConstants.commentTextFontColor
        label.backgroundColor = .brown
        return label
    }()
    
    lazy var commentAuthorIconImage: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.layer.cornerRadius = CommentCellConstants.commentAuthorIconSize / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func prepareForReuse() {
        commentAuthorIconImage.set(imageURL: nil)
    }
    
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
        
        addSubview(commentAuthorIconImage)
        commentAuthorIconImage.frame = viewModel.sizes.commentAuthorIconFrame
        commentAuthorIconImage.set(imageURL: viewModel.authorProfileImageUrl)
        
        addSubview(commentTopLineLabel)
        commentTopLineLabel.frame = viewModel.sizes.topTextFrame
        commentTopLineLabel.text = viewModel.userDateEditedCombinedString
        
        addSubview(commentTextLabel)
        commentTextLabel.frame = viewModel.sizes.commentTextFullSizeFrame
        commentTextLabel.text = viewModel.commentText
    }

}
