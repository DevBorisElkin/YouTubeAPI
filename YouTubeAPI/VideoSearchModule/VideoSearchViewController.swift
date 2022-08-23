//
//  VideoSearchViewController.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import Foundation
import UIKit

class VideoSearchViewController: UIViewController, VideoSearchPresenterToViewProtocol {
    
    var presenter: VideoSearchViewToPresenterProtocol?
    
    func onFetchVideosListStarted() {
        loadingDataStarted()
    }
    
    func onFetchVideosListSuccess() {
        loadingDataEnded()
        tableView.reloadData()
    }
    
    func onFetchVideosListFail(error: Error) {
        loadingDataEnded()
        if let error = error as? NetworkingHelpers.NetworkRequestError, error == .youTubeQuotaExceeded {
            present(UIHelpers.createAlertController(title: AppConstants.ytQuotaExceededTitle, message: AppConstants.ytQuotaExceededMessage), animated: true)
        }
    }
    
    // MARK: UI Elements
    
    private let searchTitleView = SearchTitleView()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setUpUI()
        presenter?.viewDidLoad()
    }
    
    private func setUpUI(){
        self.navigationItem.titleView = searchTitleView
        searchTitleView.onSearchExecutedDelegate = self
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: VideoSearchConstants.tableViewInsets)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = createRefreshControl()
        tableView.register(YouTubeVideoSearchCell.self, forCellReuseIdentifier: YouTubeVideoSearchCell.reuseId)
    }
    
    private func loadingDataStarted(){
        self.tableView.tableFooterView = UIHelpers.createSpinnerFooterWithConstraints(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
    }
    
    private func loadingDataEnded(){
        self.tableView.tableFooterView = nil
        
        if let refreshControl = tableView.refreshControl, refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
    }
}

// MARK: pull to refresh
extension VideoSearchViewController {
    
    private func createRefreshControl() -> UIRefreshControl{
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onCalledToRefresh(sender:)), for: .valueChanged)
        return refreshControl
    }
    
    @objc private func onCalledToRefresh(sender: UIRefreshControl){
        print("onCalledToRefresh")
        presenter?.refresh()
    }
}

extension VideoSearchViewController: SearchTitleOnSearchExecuted {
    func onSearchExecuted(for text: String) {
        scrollToTop()
        presenter?.getVideos(requestDetails: .searchRequest(requestPurpose: .refresh, request: text, pageToken: nil))
    }
}

extension VideoSearchViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
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
        let scrollPointToLoadMoreContent: CGFloat = scrollView.contentSize.height + VideoSearchConstants.videoInsetToLoadMoreComments
        
        if(bottomPoint > scrollPointToLoadMoreContent && tableView.tableFooterView == nil){
            print("fetch more data")
            presenter?.videosPaginationRequest()
        }
    }
    
    private func scrollToTop() {
        if presenter?.canScrollProgrammatically() ?? false {
            let topRow = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
        }
    }
}
