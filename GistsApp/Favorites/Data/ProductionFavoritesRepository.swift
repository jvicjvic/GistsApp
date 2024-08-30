//
//  ProductionFavoritesRepository.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation

final class ProductionFavoritesRepository: FavoritesRepository {
    private let favoritesManager = FavoritesManager()

    func fetchFavorites() -> [FavoriteGist] {
        favoritesManager.fetchFavoriteGists()
    }

    func setFavorite(gist: FavoriteGist, isFavorite: Bool) {
        if isFavorite {
            favoritesManager.saveFavoriteGist(gist)
        } else {
            favoritesManager.removeFavoriteGist(gist)
        }
    }

    func isFavorite(id: String) -> Bool {
        favoritesManager.isFavorite(id: id)
    }
}
