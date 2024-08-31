//
//  FavoriteRepository.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation

public protocol FavoritesRepository {
    func fetchFavorites<T: FavoriteItem>() -> [T]
    func setFavorite<T: FavoriteItem>(item: T, isFavorite: Bool)
    func isFavorite<T: FavoriteItem>(item: T) -> Bool
}
