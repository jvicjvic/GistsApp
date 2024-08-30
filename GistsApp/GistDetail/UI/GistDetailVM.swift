//
//  GistDetailVM.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation
import NetworkService
import UIKit

@MainActor
final class GistDetailVM: ObservableObject {
    @Published private(set) var gist: Gist?
    private var gistId: String
    @Published private(set) var fileContent: String?
    @Published var errorMessage = ""
    @Published var avatarImage: UIImage?
    @Published var isFavorite: Bool?

    private let favoritesRepository: FavoritesRepository
    private let repository: GistRepository

    var title: String? {
        gist?.filename
    }

    var headerTitle: String? {
        guard let gist else { return nil }
        return "\(gist.owner.login) / \(gist.filename)"
    }

    init(gistId: String, repository: GistRepository = ProductionGistRepository(), favoritesRepository: FavoritesRepository = ProductionFavoritesRepository()) {
        self.gistId = gistId
        self.repository = repository
        self.favoritesRepository = favoritesRepository
    }

    func connect() {
        performFetchGist()
    }

    private func performFetchGist() {
        Task {
            do {
                isFavorite = favoritesRepository.isFavorite(id: gistId)
                let gistItem = try await repository.fetchGist(gistId: gistId)
                avatarImage = await NetworkUtil.fetchImage(from: gistItem.owner.avatarUrl)
                gist = gistItem

                fileContent = try await fetchFileContent()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func fetchFileContent() async throws -> String? {
        // Obtem conteudo do primeiro arquivo da lista
        guard let gist,
                let gistFile = gist.files.first?.value,
                let fileUrl = gistFile.url else {
            return nil
        }

        return try await NetworkUtil.fetchFileContent(from: fileUrl)
    }

    func didTapFavorite() {
        guard let gist else { return }
        let favoriteGist = FavoriteGist(id: gist.id,
                                        fileCount: gist.fileCount,
                                        ownerLogin: gist.owner.login,
                                        filename: gist.filename, 
                                        avatarUrl: gist.owner.avatarUrl)

        var newStatus = isFavorite ?? false
        newStatus.toggle()
        favoritesRepository.setFavorite(gist: favoriteGist, isFavorite: newStatus)
        isFavorite = newStatus
    }
}
