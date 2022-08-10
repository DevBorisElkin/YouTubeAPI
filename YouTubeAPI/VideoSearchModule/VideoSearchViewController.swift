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
    
    func onFetchVideosListSuccess() {
        tableView.reloadData()
    }
    
    func onFetchVideosListFail() {
        
    }
    
    func showActivity() {
        
    }
    
    func hideActivity() {
        
    }
    
    // MARK: UI Elements
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .purple
        return tableView
    }()
    
    private var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        return textField
    }()
    
    private var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.setTitle("Search", for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(searchTextField)
        searchTextField.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: VideoSearchConstants.searchFieldInsets, size: CGSize(width: view.frame.width * VideoSearchConstants.searchFieldSize.width, height: VideoSearchConstants.searchFieldSize.height))
        
        view.addSubview(searchButton)
        searchButton.anchor(top: view.layoutMarginsGuide.topAnchor, leading: searchTextField.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: VideoSearchConstants.searchButonInsets)
        
        searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.anchor(top: searchTextField.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: VideoSearchConstants.tableViewInsets)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(YouTubeVideoSearchCell.self, forCellReuseIdentifier: YouTubeVideoSearchCell.reuseId)
    }
    
    @objc private func searchButtonPressed(_ sender: Any){
        print("searchButtonPressed")
        
        guard let text = searchTextField.text, !text.isEmpty else { print("empty search or something else"); return }
        
        presenter?.performSearch(for: text)
    }
}

extension VideoSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter?.setCell(tableView: tableView, forRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.tableViewCellHeight() ?? 100
    }
}
