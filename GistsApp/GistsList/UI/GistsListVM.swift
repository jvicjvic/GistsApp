//
//  GistsVM.swift
//  GistsApp
//
//  Created by jvic on 28/08/24.
//

import Foundation
import NetworkService
import UIKit
import Commons
import OSLog

@MainActor
final class GistsListVM {
    @Published private(set) var gists: [Gist] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    @Published var selectedItem: Gist?

    let title = "Gists"

    private var currentPage = 1

    private let repository: GistRepository

    init(repository: GistRepository = ProductionGistRepository()) {
        self.repository = repository
    }

    func connect() {
        performFetchGists()
    }

    private func performFetchGists() {
        Task {
            await fetchGists()
        }
    }

    private func fetchGists() async {
        do {
            isLoading = true
            let newGists = try await repository.fetchPublicGists(page: currentPage)
            gists.append(contentsOf: newGists)
        } catch {
            Logger.network.error("Ocorreu um erro: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    func loadAvatar(gist: Gist) async -> UIImage? {
        do {
            return try await repository.fetchAvatarImage(gist)
        } catch {
            Logger.network.error("Ocorreu um erro: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        return nil
    }

    func didReachEnd() {
        // carrega mais
        currentPage += 1
        performFetchGists()
    }

    func didSelect(index: Int) {
        selectedItem = gists[index]
    }
}
