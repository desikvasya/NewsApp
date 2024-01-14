//
//  NewsCell.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

final class NewsCell: UITableViewCell {
    static let identifier = "NewsCell"
    
    var newsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(loadingIndicator)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: newsImage.leadingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -5),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: newsImage.leadingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            newsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            newsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            newsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            newsImage.widthAnchor.constraint(equalToConstant: 160),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: newsImage.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: newsImage.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.image = nil
        loadingIndicator.stopAnimating()
    }
    
    func configure(with viewModel: NewsViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        if let data = viewModel.imageData {
            loadingIndicator.stopAnimating()
            newsImage.image = UIImage(data: data)
        } else if let imageURL = viewModel.imageURL {
            loadingIndicator.startAnimating()
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                defer {
                    DispatchQueue.main.async {
                        self?.loadingIndicator.stopAnimating()
                    }
                }
                
                if let error = error {
                    print("Error loading image data: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No image data received")
                    return
                }
                
                viewModel.imageData = data
                
                DispatchQueue.main.async {
                    self?.newsImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
