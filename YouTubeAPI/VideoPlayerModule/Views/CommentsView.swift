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
    
    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .brown
        return view
    }()
    
    var table: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.reuseId)
        return tableView
    }()
    
    func initialSetUp(presenter: VideoPlayerViewIntoPresenterProtocol){
        self.presenter = presenter
        
        addSubview(topView)
        topView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        topView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(table)
        table.anchor(top: topView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        table.delegate = self
        table.dataSource = self
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
        self.table.tableFooterView = UIHelpers.createSpinnerFooter(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
    }
    
    func loadingDataEnded(){
        self.table.tableFooterView = nil
    }
}
