//
//  FavoritesCoordinator.swift
//  GistsApp
//
//  Created by jvic on 30/08/24.
//

import Foundation
import UIKit
import Combine
import Coordinator

class FavoritesCoordinator: NavigatorCoordinator {
    var rootViewController: UINavigationController

    var childCoordinators = [Coordinator]()

    var cancellables = Set<AnyCancellable>()

    @MainActor lazy var listViewModel: FavoritesListVM = {
        let viewModel = FavoritesListVM()
        // apresenta detalhe
        viewModel.$selectedItem
            .compactMap { $0 }
            .sink { [weak self] gist in
                self?.presentDetail(gist: gist)
            }
            .store(in: &cancellables)

        return viewModel
    }()

    init() {
        rootViewController = UINavigationController()
    }

    func start() {
        let favoritesVC = FavoritesListVC(viewModel: listViewModel)
        rootViewController.setViewControllers([favoritesVC], animated: false)
    }

    @MainActor func presentDetail(gist: FavoriteGist) {
        let detailVC = GistDetailVC(viewModel: GistDetailVM(gistId: gist.id))
        rootViewController.pushViewController(detailVC, animated: true)
    }
}
