//
//  CommentsView.swift
//  YouTubeAPI
//
//  Created by test on 20.08.2022.
//

import Foundation
import UIKit

class CommentsView: UIView {
    
    weak var presenter: VideoPlayerViewIntoPresenterProtocol?
    
    // MARK: Top view related
    
    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var commentsText: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Comments"
        label.textColor = CommentCellConstants.commentTopLabelColor
        label.font = CommentCellConstants.commentTopLabelFont
        return label
    }()
    
    var closeCommentsButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var buttonImage = UIImage(named: "close_2")
        button.setImage(buttonImage, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    var topViewSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CommentCellConstants.commentsTopViewSeparatorColor
        return view
    }()
    
    // MARK: Table view related
    
    var table: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.reuseId)
        return tableView
    }()
    
    func initialSetUp(presenter: VideoPlayerViewIntoPresenterProtocol){
        self.presenter = presenter
        
        // MARK: Constraints and settings for top view
        addSubview(topView)
        topView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        topView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        topView.addSubview(topViewSeparator)
        topViewSeparator.anchor(top: nil, leading: topView.leadingAnchor, bottom: topView.bottomAnchor, trailing: topView.trailingAnchor)
        topViewSeparator.heightAnchor.constraint(equalToConstant: CommentCellConstants.commentsTopViewSeparatorHeight).isActive = true
        
        topView.addSubview(commentsText)
        commentsText.anchor(top: nil, leading: topView.leadingAnchor, bottom: topView.bottomAnchor, trailing: nil, padding: CommentCellConstants.commentTopLabelInsets)
        
        topView.addSubview(closeCommentsButton)
        closeCommentsButton.centerYAnchor.constraint(equalTo: commentsText.centerYAnchor).isActive = true
        closeCommentsButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -CommentCellConstants.closeCommentsButtonInsets.right).isActive = true
        closeCommentsButton.addTarget(self, action: #selector(closeCommentsButtonPressed(_:)), for: .touchUpInside)
        closeCommentsButton.imageView?.sizeToFit()
        closeCommentsButton.heightAnchor.constraint(equalToConstant: CommentCellConstants.closeCommentsButtonSizes.height).isActive = true
        closeCommentsButton.widthAnchor.constraint(equalToConstant: CommentCellConstants.closeCommentsButtonSizes.width).isActive = true
        
        // MARK: Constraints and settings for table view
        addSubview(table)
        table.anchor(top: topView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        table.delegate = self
        table.dataSource = self
    }
    
    @objc private func closeCommentsButtonPressed(_ sender: Any?){
        print("closeCommentsButtonPressed")
        presenter?.closeCommentsButtonpPressed()
    }
    
    func refreshData(){
        table.reloadData()
    }
}

extension CommentsView: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter?.setCell(tableView: tableView, forRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.tableViewCellHeight(at: indexPath) ?? 100
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomPoint: CGFloat = scrollView.contentOffset.y + scrollView.bounds.size.height
        let scrollPointToLoadMoreContent: CGFloat = scrollView.contentSize.height + CommentCellConstants.commentInsetToLoadMoreComments
        
        if(bottomPoint > scrollPointToLoadMoreContent && table.tableFooterView == nil){
            print("fetch more data")
            presenter?.commentsPaginationRequest()
        }
    }
    
    func loadingDataStarted(){
        self.table.tableFooterView = UIHelpers.createSpinnerFooterWithConstraints(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
    }
    
    func loadingDataEnded(){
        self.table.tableFooterView = nil
    }
}
