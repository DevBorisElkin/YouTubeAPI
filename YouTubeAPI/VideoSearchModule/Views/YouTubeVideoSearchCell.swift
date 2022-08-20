//
//  YouTubeVideoSearchCell.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import UIKit
import youtube_ios_player_helper

class YouTubeVideoSearchCell: UITableViewCell {

    static let reuseId = "YouTubeVideoSearchCell"
    
    var presenter: VideoSearchVideoCellToPresenterProtocol?
    var viewModel: VideoViewModel?
    
    // TODO add some UI
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.cornerRadius = 20
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // shadow setup
        //view.layer.shadowColor = #colorLiteral(red: 0.09200996906, green: 0.08846413344, blue: 0.1079702899, alpha: 1)
        //view.layer.shadowRadius = 3
        //view.layer.shadowOpacity = 0.2
        //view.layer.shadowOffset = CGSize(width: 5, height: 10)
        
        return view
    }()
    
    lazy var videoThumbnailImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = .blue
        
        //imageView.layer.cornerRadius = 20
        
        imageView.layer.masksToBounds = true
        //imageView.layer.cornerRadius = Constants.repoOwnerAvatarSize / 2
        
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var channelIconImage: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.layer.cornerRadius = VideoCellConstants.channelIconSize / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var videoNamelLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = VideoCellConstants.videoNameFontColor
        label.font = VideoCellConstants.videoNameFont
        return label
    }()
    
    lazy var videoDetailsLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = VideoCellConstants.videoDetailsFontColor
        label.font = VideoCellConstants.videoDetailsFont
        return label
    }()
    
    lazy var openVideoButton: UIButton = {
        let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        videoThumbnailImageView.set(imageURL: nil)
        channelIconImage.set(imageURL: nil)
    }
    
    func setUpConstraints(){
        // MARK: cardView
        addSubview(cardView)
        cardView.fillSuperview(padding: VideoCellConstants.cardViewOffset)
        
        // MARK: imageHolderView
        cardView.addSubview(videoThumbnailImageView)
        
        // MARK: channel icon
        cardView.addSubview(channelIconImage)
        
        cardView.addSubview(videoNamelLabel)
        cardView.addSubview(videoDetailsLabel)
        
        // MARK: playerView TODO load only when needed
//        contentView.addSubview(playerView)
//        playerView.fillSuperview(padding: VideoCellConstants.cardViewOffset)
        
        contentView.addSubview(openVideoButton)
        openVideoButton.addTarget(self, action: #selector(openVideoButtonPressed(_:)), for: .touchUpInside)
        
        // todo videoButtonConstraints
    }
    
    func setUp(viewModel: VideoViewModel){
        self.viewModel = viewModel
        
        videoThumbnailImageView.frame = viewModel.sizes.imageFrame
        videoThumbnailImageView.set(imageURL: viewModel.thumbnailUrl)
        
        channelIconImage.frame.size = CGSize(width: VideoCellConstants.channelIconSize, height: VideoCellConstants.channelIconSize)
        channelIconImage.frame.origin = CGPoint(x: VideoCellConstants.channelIconInsets.left, y: videoThumbnailImageView.frame.maxY + VideoCellConstants.channelIconInsets.top)
        
        channelIconImage.set(imageURL: viewModel.channelImageUrl)
        
        videoNamelLabel.text = viewModel.videoNameString
        videoNamelLabel.frame = viewModel.sizes.videoNameFrame
        
        videoDetailsLabel.text = viewModel.detailsString
        videoDetailsLabel.frame = viewModel.sizes.videoDetailsFrame
        
        // video button position
        openVideoButton.frame = viewModel.sizes.imageFrame
    }
    
    @objc private func openVideoButtonPressed(_ sender: Any){
        print("Open video button pressed")
        guard let viewModel = viewModel, let presenter = presenter else {
            print("Button doesn't have presenter or data")
            return
        }
        presenter.requestedToOpenVideo(with: viewModel)
    }
}
