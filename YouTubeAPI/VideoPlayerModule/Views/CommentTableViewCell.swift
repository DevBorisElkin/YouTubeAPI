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
        //label.backgroundColor = .brown
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var commentTextLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = CommentCellConstants.commentTextFont
        label.textColor = CommentCellConstants.commentTextFontColor
        //label.backgroundColor = .brown
        label.backgroundColor = .clear
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
    
    lazy var moreTextButton: UIButton = {
        let button = UIButton()
        var textColor = #colorLiteral(red: 0.2330949306, green: 0.2231936157, blue: 0.2745918632, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(textColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Read more", for: .normal)
        button.backgroundColor = .brown
        return button
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
    
    func setUp(viewModel: CommentViewModel, presenter: VideoPlayerViewIntoPresenterProtocol){
        self.viewModel = viewModel
        self.presenter = presenter
        print("setUp -> comment cell")
        
        addSubview(commentAuthorIconImage)
        commentAuthorIconImage.frame = viewModel.sizes.commentAuthorIconFrame
        commentAuthorIconImage.set(imageURL: viewModel.authorProfileImageUrl)
        
        addSubview(commentTopLineLabel)
        commentTopLineLabel.frame = viewModel.sizes.topTextFrame
        commentTopLineLabel.text = viewModel.userDateEditedCombinedString
        
        addSubview(commentTextLabel)
        commentTextLabel.frame = viewModel.sizes.commentTextFrame
        commentTextLabel.text = viewModel.commentText
        
        addSubview(moreTextButton)
        moreTextButton.frame = viewModel.sizes.expandCommentTextButtonFrame
        moreTextButton.addTarget(self, action: #selector(showFullCommentText), for: .touchUpInside)
    }
    
    @objc private func showFullCommentText(_ sender: Any){
        print("Show full text button pressed")
        presenter?.expandTextForComment(commentId: viewModel.commentId)
    }
}
