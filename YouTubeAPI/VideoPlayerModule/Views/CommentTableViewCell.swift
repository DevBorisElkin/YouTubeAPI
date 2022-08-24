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
    
    lazy var moreTextButton: ExpandedButton = {
        let button = ExpandedButton()
        button.clickIncreasedArea = AppConstants.expandCustomButtonsClickArea
        var textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(textColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Read more", for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    let likesCount: ImageCounterView = {
        let view = ImageCounterView()
        //view.backgroundColor = .brown
        return view
    }()
    
    let repliesCount: ImageCounterView = {
        let view = ImageCounterView()
        //view.backgroundColor = .blue
        return view
    }()
    
    override func prepareForReuse() {
        commentAuthorIconImage.set(imageURL: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
        
        addSubview(commentAuthorIconImage)
        commentAuthorIconImage.frame = viewModel.sizes.commentAuthorIconFrame
        commentAuthorIconImage.set(imageURL: viewModel.authorProfileImageUrl, cacheAndRetrieveImage: false)
        
        addSubview(commentTopLineLabel)
        commentTopLineLabel.frame = viewModel.sizes.topTextFrame
        commentTopLineLabel.text = viewModel.userDateEditedCombinedString
        
        addSubview(commentTextLabel)
        commentTextLabel.frame = viewModel.sizes.commentTextFrame
        commentTextLabel.text = viewModel.commentText
        
        addSubview(moreTextButton)
        moreTextButton.frame = viewModel.sizes.expandCommentTextButtonFrame
        moreTextButton.addTarget(self, action: #selector(showFullCommentText), for: .touchUpInside)
        
        addSubview(likesCount)
        likesCount.frame = viewModel.sizes.likesFrame
        likesCount.setUp(imageName: "like_2", text: viewModel.likeCount, iconYImageOffset: 0)
        
        addSubview(repliesCount)
        repliesCount.frame = viewModel.sizes.repliesFrame
        repliesCount.setUp(imageName: "com_1", text: viewModel.totalReplyCount, iconYImageOffset: 1.8)
    }
    
    @objc private func showFullCommentText(_ sender: Any){
        print("Show full text button pressed")
        presenter?.expandTextForComment(commentId: viewModel.commentId)
    }
}

class ImageCounterView: UIView {
    
    var image: UIImageView!
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.5, weight: .regular)
        label.textColor = #colorLiteral(red: 0.3959505427, green: 0.3950697562, blue: 0.4164385191, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUp(imageName: String, text: String, iconYImageOffset: CGFloat = 0){
        setUpImage(imageName: imageName)
        label.text = text
        
        setUpConstraints(iconYImageOffset: iconYImageOffset)
    }
    
    private func setUpImage(imageName: String){
        let uiImage = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: uiImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        image = imageView
    }
    
    private func setUpConstraints(iconYImageOffset: CGFloat){
        addSubview(image)
        image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: iconYImageOffset).isActive = true
        image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        image.heightAnchor.constraint(equalToConstant: 15).isActive = true
        image.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(label)
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //label.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
