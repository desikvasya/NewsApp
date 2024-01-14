//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 14.01.2024.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private var favorites = [FavoriteNewsViewModel]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchData() {
        favorites = FavoritesManager.shared.getFavorites()
        tableView.reloadData()
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchPoint = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            let selectedNews = favorites[indexPath.row]
            showContextMenu(for: selectedNews, at: indexPath)
        }
    }
    
    private func showContextMenu(for news: FavoriteNewsViewModel, at indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let removeAction = UIAlertAction(title: "Remove from Favorites", style: .destructive) { [weak self] _ in
            self?.removeFromFavorites(at: indexPath)
        }
        alertController.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func removeFromFavorites(at indexPath: IndexPath) {
        FavoritesManager.shared.removeFavorite(at: indexPath.row)
        fetchData()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier, for: indexPath) as? FavoritesCell else {
            fatalError()
        }
        cell.configure(with: favorites[indexPath.row])
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = favorites[indexPath.row]
        
        let detailedVC = DetailedViewController()
        detailedVC.selectedImage = selectedNews.imageURL.flatMap { UIImage(contentsOfFile: $0.path) }
        detailedVC.selectedTitle = selectedNews.title
        detailedVC.selectedDescription = selectedNews.description
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
}

extension FavoritesViewController: NewsViewControllerDelegate {
    
    func didUpdateFavorites() {
        fetchData()
    }
    
    func removeFromFavorites(_ news: FavoriteNewsViewModel) {
        if let index = favorites.firstIndex(where: { $0.title == news.title && $0.description == news.description }) {
            favorites.remove(at: index)
        }
        
        tableView.reloadData()
    }
}


