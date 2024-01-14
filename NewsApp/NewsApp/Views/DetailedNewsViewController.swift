//
//  DetailedNewsViewController.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 14.01.2024.
//

import UIKit

final class DetailedViewController: UIViewController {
    var selectedImage: UIImage?
    var selectedTitle: String?
    var selectedDescription: String?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        configureUIElements()
    }
    
    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        view.addSubview(titleLabel)
        
        let descriptionScrollView = UIScrollView()
        descriptionScrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(descriptionScrollView)
        descriptionScrollView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionScrollView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionScrollView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionScrollView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: descriptionScrollView.widthAnchor),
        ])
    }
    
    private func configureUIElements() {
        imageView.image = selectedImage
        titleLabel.text = selectedTitle
        descriptionLabel.text = selectedDescription
    }
}
