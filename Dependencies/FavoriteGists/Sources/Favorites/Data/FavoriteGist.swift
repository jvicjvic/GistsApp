//
//  FavoriteGist.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation

public struct FavoriteGist: FavoriteItem {
    public let id: String
    public let fileCount: Int
    public let ownerLogin: String
    public let filename: String
    public let avatarUrl: String

    public var favoriteTitle: String {
        "\(ownerLogin) / \(filename)"
    }

    public var favoriteSubtitle: String {
        "\(fileCount) arquivo(s)"
    }

    public init(id: String, fileCount: Int = 0, ownerLogin: String = "", filename: String = "", avatarUrl: String = "") {
        self.id = id
        self.fileCount = fileCount
        self.ownerLogin = ownerLogin
        self.filename = filename
        self.avatarUrl = avatarUrl
    }
}
