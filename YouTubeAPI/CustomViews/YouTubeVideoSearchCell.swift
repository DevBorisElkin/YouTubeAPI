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
    
    var viewModel: VideoViewModel?
    
    // TODO add some UI
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.cornerRadius = 20
        view.backgroundColor = #colorLiteral(red: 0.800581634, green: 0.589300096, blue: 1, alpha: 1)
        
        // shadow setup
        view.layer.shadowColor = #colorLiteral(red: 0.09200996906, green: 0.08846413344, blue: 0.1079702899, alpha: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 5, height: 10)
        
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
    
    lazy var videoNamelLbel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .brown
        label.textColor = .black
        return label
    }()
    
    lazy var videoDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .brown
        label.textColor = .black
        return label
    }()
    
    
//    lazy var playerView: YTPlayerView = {
//        var playerView = YTPlayerView()
//        playerView.backgroundColor = .black
//        playerView.translatesAutoresizingMaskIntoConstraints = false
//        return playerView
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints(){
        // MARK: cardView
        addSubview(cardView)
        cardView.fillSuperview(padding: VideoCellConstants.cardViewOffset)
        
        // MARK: imageHolderView
        cardView.addSubview(videoThumbnailImageView)
        
        // MARK: playerView TODO load only when needed
//        contentView.addSubview(playerView)
//        playerView.fillSuperview(padding: VideoCellConstants.cardViewOffset)
    }
    
    func setUp(viewModel: VideoViewModel){
        self.viewModel = viewModel
        
        videoThumbnailImageView.frame = viewModel.imageFrame
        videoThumbnailImageView.set(imageURL: viewModel.thumbnailUrl)
    }
}
