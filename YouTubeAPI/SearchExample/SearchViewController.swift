//
//  SearchViewController.swift
//  YouTubeAPI
//
//  Created by test on 10.08.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func searchButtonPressed(_ sender: Any) {
        print("search button pressed")
        searchTextField.resignFirstResponder()
        
        guard let text = searchTextField.text, !text.isEmpty else { print("empty text"); return }
        
        NetworkingHelpers.decodeDataWithResult(from: YouTubeHelper.getVideosSearchRequestString(for: text), type: SearchResultWrapped.self, printJSON: true) { result in
            switch(result){
                
            case .success(let data):
                print("received data:\n\(data)")
            case .failure(let error):
                print("Failed to load data: \(error.localizedDescription)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    func setUp(){
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: SearchResultCell.reuseId)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseId, for: indexPath)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
}
