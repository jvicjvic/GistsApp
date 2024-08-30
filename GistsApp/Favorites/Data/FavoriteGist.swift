//
//  FavoriteGist.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import Foundation

struct FavoriteGist: Codable {
    let id: String
    let fileCount: Int
    let ownerLogin: String
    let filename: String
    let avatarUrl: String
}
