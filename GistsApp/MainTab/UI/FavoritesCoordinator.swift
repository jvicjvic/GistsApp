//
//  FavoritesCoordinator.swift
//  GistsApp
//
//  Created by jvic on 30/08/24.
//

import Combine
import Coordinator
import FavoriteGists
import Foundation
import UIKit

/// Navegação da tela de Favoritos
class FavoritesCoordinator: NavigatorCoordinator {
    var rootViewController: UINavigationController

    var childCoordinators = [Coordinator]()

    var cancellables = Set<AnyCancellable>()

    @MainActor lazy var listViewModel: FavoritesListVM = {
        let viewModel = FavoritesListVM<Gist>()

        // apresenta detalhe na selecao do item
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

    @MainActor func presentDetail(gist: Gist) {
        let detailVC = GistDetailVC(viewModel: GistDetailVM(gist: gist))
        rootViewController.pushViewController(detailVC, animated: true)
    }
}
