//
//  NewsCell.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

final class NewsViewModel {
    let title: String
    let description: String
    let imageURL: URL?
    
    init(title: String, description: String, imageURL: URL?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}

final class NewsCell: UITableViewCell {
    static let identifier = "NewsCell"
    
    var newsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15,
                                  y: 0,
                                  width: contentView.frame.size.width - 120,
                                  height: 70)
        descriptionLabel.frame = CGRect(x: 15,
                                  y: 70,
                                  width: contentView.frame.size.width - 120,
                                  height: contentView.frame.size.height / 2)
        newsImage.frame = CGRect(x: contentView.frame.size.width - 200,
                                  y: 10,
                                  width: contentView.frame.size.width - 120,
                                  height: contentView.frame.size.height / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: NewsViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        if let imageURL = viewModel.imageURL {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.newsImage.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            newsImage.image = UIImage(named: "placeholderImage")
        }
    }
    
    
    
}



