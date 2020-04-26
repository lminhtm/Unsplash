//
//  FavoriteManager.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation

class FavoriteManager {
    
    // MARK: - Properties
    
    private let favoritesKey = "favoritesKey"
    private var favorites: [Photo] = []
    
    /// Shared data manager object.
    static let shared = FavoriteManager()
    
    // MARK: - Initialization
    
    private init() {
        // Fetch favorites
        if let data = UserDefaults.standard.object(forKey: favoritesKey) as? Data {
            let decoder = JSONDecoder()
            if let favorites = try? decoder.decode([Photo].self, from: data) {
                self.favorites = favorites
            }
        }
    }
    
    // MARK: - Process
    
    private func cleanupFavorites() {
        favorites.removeAll()
        updateFavorites()
    }
    
    private func updateFavorites() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
        else {
            UserDefaults.standard.set(nil, forKey: favoritesKey)
        }
        
        // Broadcast
        NotificationCenter.default.post(name: .didChangeFavorites, object: nil)
    }
}

// MARK: - Public

extension FavoriteManager {
    
    func getFavorites() -> [Photo] {
        return favorites
    }
    
    func isFavorite(_ photo: Photo) -> Bool {
        return favorites.contains(photo)
    }
    
    func addFavorite(_ photo: Photo) {
        favorites.insert(photo, at: 0)
        updateFavorites()
    }
    
    func removeFavorite(_ photo: Photo) {
        favorites.removeAll { $0 == photo }
        updateFavorites()
    }
}

// MARK: - Notification

extension Notification.Name {
    static let didChangeFavorites = Notification.Name("didChangeFavorites")
}
