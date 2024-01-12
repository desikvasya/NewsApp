//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    private var viewModels = [NewsViewModel]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Новости"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        APICaller.shared.getTopNews { [weak self] result in
            switch result {
            case .success(let result):
                self?.viewModels = result.compactMap({
                    NewsViewModel(title: $0.title,
                                  description: $0.description ?? "No description",
                                  imageURL: URL(string: $0.imageURL ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
}

