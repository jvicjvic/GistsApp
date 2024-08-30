//
//  FavoriteGistsListVM.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation
import UIKit
import NetworkService

@MainActor
final class FavoritesListVM: ObservableObject {
    @Published private(set) var gists: [FavoriteGist] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage = ""

    let title = "Favoritos"

    private var currentPage = 1

    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = ProductionFavoritesRepository()) {
        self.repository = repository
    }

    func connect() {
        fetchGists()
    }

    private func fetchGists() {
        gists = repository.fetchFavorites()
    }

    func loadGistUserAvatar(gist: FavoriteGist) async -> UIImage? {
        await NetworkUtil.fetchImage(from: gist.avatarUrl)
    }
}
