//
//  FavoritesManager.swift
//  NewsApp
//
//  Created by Eren Aşkın on 13.05.2024.
//


import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let userDefaults = UserDefaults.standard
    private let favoriteKey = "FavoriteArticles"

    var favoriteArticles: [Article] {
        get {
            // UserDefaults'tan favori makaleleri al
            if let data = userDefaults.data(forKey: favoriteKey),
               let articles = try? JSONDecoder().decode([Article].self, from: data) {
                return articles
            } else {
                return []
            }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: favoriteKey)
            }
        }
    }
    
    private init() {}
    
    func addFavorite(article: Article) {
        var favorites = favoriteArticles
        favorites.append(article)
        favoriteArticles = favorites
    }
    
    func removeFavorite(article: Article) {
        var favorites = favoriteArticles
        if let index = favorites.firstIndex(where: { $0.title == article.title }) {
            favorites.remove(at: index)
            favoriteArticles = favorites
        }
    }
    
    func isFavorite(article: Article) -> Bool {
        return favoriteArticles.contains(where: { $0.title == article.title })
    }
}

