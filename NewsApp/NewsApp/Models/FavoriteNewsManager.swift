//
//  FavoriteNewsManager.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 14.01.2024.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let favoritesKey = "favorites"
    
    private init() {}
    
    func getFavorites() -> [FavoriteNewsViewModel] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            do {
                let favorites = try JSONDecoder().decode([FavoriteNewsViewModel].self, from: data)
                return favorites
            } catch {
                print("Error decoding favorites: \(error)")
            }
        }
        return []
    }
    
    func addFavorite(_ favorite: FavoriteNewsViewModel) {
        var favorites = getFavorites()
        favorites.append(favorite)
        saveFavorites(favorites)
    }
    
    func removeFavorite(at index: Int) {
        var favorites = getFavorites()
        favorites.remove(at: index)
        saveFavorites(favorites)
    }
    
    private func saveFavorites(_ favorites: [FavoriteNewsViewModel]) {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}
