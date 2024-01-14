//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

final class NewsViewController: UIViewController {
    
    private var viewModels = [NewsViewModel]()
    private var nextPage: String?
    private let pageSize = 10
    
    private let refreshControl = UIRefreshControl()
    
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
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchData(completion: (() -> Void)? = nil) {
        APICaller.shared.getTopNews(page: nextPage) { [weak self] result in
            switch result {
            case .success(let apiResponse):
                let results = apiResponse.results
                if let nextPage = apiResponse.nextPage {
                    self?.nextPage = nextPage
                }
                
                let newViewModels = results.compactMap {
                    NewsViewModel(
                        title: $0.title,
                        description: $0.description ?? "No description",
                        imageURL: URL(string: $0.imageURL ?? ""),
                        imageData: nil
                    )
                }
                
                self?.viewModels.append(contentsOf: newViewModels)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    completion?()
                }
            case .failure(let error):
                print(error)
                completion?()
            }
        }
    }
    
    @objc private func refreshData() {
        nextPage = nil
        fetchData {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func loadNextPage() {
        fetchData()
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        
        if indexPath.row == viewModels.count - 1 {
            loadNextPage()
        }
        
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = viewModels[indexPath.row]
        
        let detailedVC = DetailedViewController()
        detailedVC.selectedImage = selectedNews.imageData.flatMap { UIImage(data: $0) }
        detailedVC.selectedTitle = selectedNews.title
        detailedVC.selectedDescription = selectedNews.description
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
}


