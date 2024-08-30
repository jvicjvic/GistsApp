//
//  ProductionGistRepository.swift
//  GistsApp
//
//  Created by jvic on 27/08/24.
//

import Foundation
import NetworkService

final class ProductionGistRepository: GistRepository {
    private let networkService = GistsNetworkService()

    func fetchPublicGists(page: Int) async throws -> [Gist] {
        try await networkService.fetchPublicGists(page: page)
    }

    func fetchGist(gistId: String) async throws -> Gist {
        try await networkService.fetchGistDetails(id: gistId)
    }
}
