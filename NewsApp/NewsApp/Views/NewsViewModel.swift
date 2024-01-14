//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 14.01.2024.
//

import Foundation

final class NewsViewModel {
    let title: String
    let description: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, description: String, imageURL: URL?, imageData: Data?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.imageData = imageData
    }
}
