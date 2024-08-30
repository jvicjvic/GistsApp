//
//  FavoriteGistsListVM.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation

@MainActor
final class FavoritesListVM: ObservableObject {
    @Published private(set) var gists: [FavoriteGist] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage = ""

    let title = "Favorites"

    private var currentPage = 1

    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = ProductionFavoritesRepository()) {
        self.repository = repository
    }

    func connect() {
        fetchGists()
    }

    func fetchGists() {
        gists = repository.fetchFavorites()
    }
}
