//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

protocol NewsViewControllerDelegate: AnyObject {
    func didUpdateFavorites()
}

final class NewsViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: NewsViewControllerDelegate?
    
    private var viewModels = [NewsViewModel]()
    private var nextPage: String?
    private let pageSize = 10
    
    private let refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        return table
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Data Fetching
    
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

// MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        
        let isFavorite = FavoritesManager.shared.getFavorites().contains {
            $0.title == viewModels[indexPath.row].title && $0.description == viewModels[indexPath.row].description
        }
        cell.backgroundColor = isFavorite ? UIColor.systemPink.withAlphaComponent(0.2) : .clear
        
        if indexPath.row == viewModels.count - 1 {
            loadNextPage()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

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

// MARK: - Long Press Gesture

extension NewsViewController {
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchPoint = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            let selectedNews = viewModels[indexPath.row]
            showContextMenu(for: selectedNews, at: indexPath)
        }
    }
    
    private func showContextMenu(for news: NewsViewModel, at indexPath: IndexPath) {
        let isFavorite = FavoritesManager.shared.getFavorites().contains {
            $0.title == news.title && $0.description == news.description
        }
        
        let actionTitle = isFavorite ? "Remove from Favorites" : "Add to Favorites"
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
            if isFavorite {
                self?.removeFromFavorites(at: indexPath)
            } else {
                self?.addToFavorites(news)
            }
        }
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func addToFavorites(_ news: NewsViewModel) {
        let favorite = FavoriteNewsViewModel(
            title: news.title,
            description: news.description,
            imageURL: news.imageURL
        )
        
        // сохраняем картинку, название и описание в UserDefaults
        if let imageData = news.imageData {
            UserDefaults.standard.set(imageData, forKey: "FavoriteImageData_\(favorite.title)")
        }
        UserDefaults.standard.set(favorite.title, forKey: "FavoriteTitle_\(favorite.title)")
        UserDefaults.standard.set(favorite.description, forKey: "FavoriteDescription_\(favorite.title)")
        
        FavoritesManager.shared.addFavorite(favorite)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        
        delegate?.didUpdateFavorites()
    }

    
    private func removeFromFavorites(at indexPath: IndexPath) {
        let removedNews = viewModels[indexPath.row]
        
        // удаляем из UserDefaults
        UserDefaults.standard.removeObject(forKey: "FavoriteImageData_\(removedNews.title)")
        UserDefaults.standard.removeObject(forKey: "FavoriteTitle_\(removedNews.title)")
        UserDefaults.standard.removeObject(forKey: "FavoriteDescription_\(removedNews.title)")
        
        FavoritesManager.shared.removeFavorite(at: indexPath.row)
        
        if let index = viewModels.firstIndex(where: { $0.title == removedNews.title && $0.description == removedNews.description }) {
            viewModels[index] = removedNews
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
        
        delegate?.didUpdateFavorites()
    }

}

