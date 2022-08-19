//
//  ChannelInfoView.swift
//  YouTubeAPI
//
//  Created by test on 18.08.2022.
//

import Foundation
import UIKit

class ChannelInfoView: UIView {
    
    lazy var channelIconImage: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.layer.cornerRadius = VideoPlayerConstants.channelIconSize / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    lazy var channelNamelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = VideoPlayerConstants.channelNameFontColor
        label.font = VideoPlayerConstants.channelNameFont
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var subscribersCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = VideoPlayerConstants.subscribersCountFontColor
        label.font = VideoPlayerConstants.subscribersCountFont
        label.backgroundColor = .clear
        return label
    }()
    
    var topSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = VideoPlayerConstants.separatorColor
        return view
    }()
    var bottomSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = VideoPlayerConstants.separatorColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints(){
        // Channel image
        addSubview(channelIconImage)
        
        channelIconImage.topAnchor.constraint(equalTo: topAnchor, constant: VideoPlayerConstants.channelIconInsets.top).isActive = true
        channelIconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: VideoPlayerConstants.channelIconInsets.left).isActive = true
        channelIconImage.heightAnchor.constraint(equalToConstant: VideoPlayerConstants.channelIconSize).isActive = true
        channelIconImage.widthAnchor.constraint(equalToConstant: VideoPlayerConstants.channelIconSize).isActive = true
        
        // stack view
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: VideoPlayerConstants.channelInfoStackViewInsets.top).isActive = true
        stackView.leadingAnchor.constraint(equalTo: channelIconImage.trailingAnchor, constant: channelIconImage.frame.maxX + VideoPlayerConstants.channelInfoStackViewInsets.left).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -VideoPlayerConstants.channelInfoStackViewInsets.right).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -VideoPlayerConstants.channelInfoStackViewInsets.bottom).isActive = true
        
        stackView.addArrangedSubview(channelNamelLabel)
        stackView.addArrangedSubview(subscribersCountLabel)
        
        addSubview(topSeparator)
        topSeparator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topSeparator.heightAnchor.constraint(equalToConstant: VideoPlayerConstants.separatorHeight).isActive = true
        
        addSubview(bottomSeparator)
        bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomSeparator.heightAnchor.constraint(equalToConstant: VideoPlayerConstants.separatorHeight).isActive = true
    }
    
    func setUp(viewModel: ChannelInfoViewModel){
        channelIconImage.set(imageURL: viewModel.channelIconUrlString)
        channelNamelLabel.text = viewModel.channelName
        subscribersCountLabel.text = viewModel.subscribersCount
    }
}
