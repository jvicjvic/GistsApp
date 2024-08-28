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

    var fileCount: Int {
        return files.count
    }

    var name: String? {
        files.count > 0 ? files.first?.value.filename : nil
    }
}

struct Owner: Codable {
    let login: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}

struct GistFile: Codable {
    let filename: String
    let content: String?
    let raw_url: String?
}
