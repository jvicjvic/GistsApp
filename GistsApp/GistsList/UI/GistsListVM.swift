//
//  GistsVM.swift
//  GistsApp
//
//  Created by jvic on 28/08/24.
//

import Foundation

@MainActor
final class GistsListVM: ObservableObject {
    @Published private(set) var gists: [Gist] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage = ""

    let title = "Gists"

    private var currentPage = 1

    private let repository: GistRepository

    init(repository: GistRepository = ProductionGistRepository(), 
         favoritesRepository: FavoritesRepository = ProductionFavoritesRepository()) {
        self.repository = repository
    }

    func connect() {
        Task {
            await fetchGists()
        }
    }

    func fetchGists() async {
        do {
            isLoading = true
            let newGists = try await repository.fetchPublicGists(page: currentPage)
            gists.append(contentsOf: newGists)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    func didReachEnd() {
        // carrega mais
        currentPage += 1
        Task {
            await fetchGists()
        }
    }
}
