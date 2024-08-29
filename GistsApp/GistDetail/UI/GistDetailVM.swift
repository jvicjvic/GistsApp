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
    private(set) var gist: Gist
    @Published private(set) var fileContent = ""
    @Published var errorMessage = ""
    @Published var avatarImage: UIImage?

    var title: String {
        gist.name
    }

    var headerTitle: String {
        "\(gist.owner.login) / \(gist.name)"
    }

    init(gist: Gist) {
        self.gist = gist
    }

    func connect() {
        Task {
            await fetchFileContent()
        }
        Task {
            await fetchAvatarImage()
        }
    }

    func fetchAvatarImage() async {
        await avatarImage = NetworkUtil.fetchImage(from: gist.owner.avatarUrl)
    }

    func fetchFileContent() async {
        // Obtem conteudo do primeiro arquivo da lista
        guard let gistFile = gist.files.first?.value, let fileUrl = gistFile.url else {
            return
        }

        do {
            fileContent = try await NetworkUtil.fetchFileContent(from: fileUrl)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
