//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

final class NewsViewController: UIViewController {
    private var viewModels = [NewsViewModel]()

    private let refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func configureUI() {
        view.backgroundColor = .red
        title = "Новости"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    private func fetchData(completion: (() -> Void)? = nil) {
        APICaller.shared.getTopNews { [weak self] result in
            switch result {
            case .success(let results):
                self?.viewModels = results.compactMap {
                    NewsViewModel(
                        title: $0.title,
                        description: $0.description ?? "No description",
                        imageURL: URL(string: $0.imageURL ?? ""),
                        imageData: nil
                    )
                }
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
        fetchData {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
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
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle selection if needed
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
