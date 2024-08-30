//
//  FavoritesManager.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation

class FavoritesManager {
    private let favoritesKey = "FavoriteGists"

    func saveFavoriteGist(_ gist: FavoriteGist) {
        var favorites = fetchFavoriteGists()
        favorites.append(gist)
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }

    func fetchFavoriteGists() -> [FavoriteGist] {
        if let savedData = UserDefaults.standard.data(forKey: favoritesKey),
           let savedGists = try? JSONDecoder().decode([FavoriteGist].self, from: savedData) {
            return savedGists
        }
        return []
    }

    func removeFavoriteGist(_ gist: FavoriteGist) {
        var favorites = fetchFavoriteGists()
        favorites.removeAll { $0.id == gist.id }
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }

    func isFavorite(id: String) -> Bool {
        let favorites = fetchFavoriteGists()
        return favorites.contains { $0.id == id }
    }
}
