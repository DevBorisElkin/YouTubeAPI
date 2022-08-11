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
    
    private var gradientView: GradientView = {
       let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        //var startColor = #colorLiteral(red: 1, green: 0.5301587371, blue: 0.7200260892, alpha: 1)
        //var endColor = #colorLiteral(red: 1, green: 0.6452286316, blue: 0.4446379992, alpha: 1)
        var startColor = #colorLiteral(red: 1, green: 0.8069414411, blue: 0.8849582529, alpha: 1)
        var endColor = #colorLiteral(red: 1, green: 0.9033621306, blue: 0.8487222892, alpha: 1)
        gradientView.setColors(startColor: startColor, endColor: endColor)
        return gradientView
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
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
        
        view.backgroundColor = #colorLiteral(red: 0.2330949306, green: 0.2231936157, blue: 0.2745918632, alpha: 1)
        setUpUI()
        presenter?.viewDidLoad()
    }
    
    private func setUpUI(){
        view.addSubview(gradientView)
        gradientView.fillSuperview()
        
        gradientView.addSubview(searchTextField)
        
        searchTextField.anchor(top: gradientView.layoutMarginsGuide.topAnchor, leading: gradientView.leadingAnchor, bottom: nil, trailing: nil, padding: VideoSearchConstants.searchFieldInsets, size: CGSize(width: view.frame.width * VideoSearchConstants.searchFieldSize.width, height: VideoSearchConstants.searchFieldSize.height))
        
        gradientView.addSubview(searchButton)
        searchButton.anchor(top: gradientView.layoutMarginsGuide.topAnchor, leading: searchTextField.trailingAnchor, bottom: nil, trailing: gradientView.trailingAnchor, padding: VideoSearchConstants.searchButonInsets)
        
        searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
        
        gradientView.addSubview(tableView)
        tableView.anchor(top: searchTextField.bottomAnchor, leading: gradientView.leadingAnchor, bottom: gradientView.bottomAnchor, trailing: gradientView.trailingAnchor, padding: VideoSearchConstants.tableViewInsets)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(YouTubeVideoSearchCell.self, forCellReuseIdentifier: YouTubeVideoSearchCell.reuseId)
    }
    
    @objc private func searchButtonPressed(_ sender: Any){
        print("searchButtonPressed")
        
        guard let text = searchTextField.text, !text.isEmpty else { print("empty search or something else"); return }
        
        searchTextField.resignFirstResponder()
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
        return presenter?.tableViewCellHeight(at: indexPath) ?? 100
    }
}
