//
//  GistRepository.swift
//  GistsApp
//
//  Created by jvic on 27/08/24.
//

import Foundation

protocol GistRepository {
    func fetchPublicGists(page: Int) async throws -> [Gist]
}
