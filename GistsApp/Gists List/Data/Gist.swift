//
//  Gist.swift
//  GistsApp
//
//  Created by jvic on 27/08/24.
//

import Foundation

struct Gist: Codable, Identifiable {
    let id: String
    let description: String?
    let owner: Owner
    let files: [String: GistFile]
}

struct Owner: Codable {
    let login: String
}

struct GistFile: Codable {
    let filename: String
    let content: String?
    let raw_url: String?
}
