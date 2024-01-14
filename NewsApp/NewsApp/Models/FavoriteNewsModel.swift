//
//  FavoriteNewsModel.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 14.01.2024.
//

import Foundation

struct FavoriteNewsViewModel: Codable {
    var title: String
    var description: String
    var imageURL: URL?
    
    init(title: String, description: String, imageURL: URL?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}
