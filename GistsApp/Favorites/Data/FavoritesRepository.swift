//
//  FavoriteRepository.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation

protocol FavoritesRepository {
    func fetchFavorites() -> [FavoriteGist]
    func setFavorite(gist: FavoriteGist, isFavorite: Bool)
    func isFavorite(id: String) -> Bool
}
