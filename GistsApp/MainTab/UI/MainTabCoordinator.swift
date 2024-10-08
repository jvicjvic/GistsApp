//
//  MainCoordinator.swift
//  GistsApp
//
//  Created by jvic on 30/08/24.
//

import Coordinator
import Foundation
import UIKit

/// Navegação da aba principal, contem a listagem principal de Gists e
/// a listagem de favoritos
class MainTabCoordinator: TabCoordinator {
    var rootViewController: UITabBarController

    var childCoordinators = [Coordinator]()

    init() {
        rootViewController = UITabBarController()
        rootViewController.tabBar.isTranslucent = true
    }

    func start() {
        let listCoordinator = GistListCoordinator()
        listCoordinator.start()

        let favoritesCoordinator = FavoritesCoordinator()
        favoritesCoordinator.start()

        childCoordinators = [listCoordinator, favoritesCoordinator]
        rootViewController.viewControllers = [listCoordinator.rootViewController,
                                              favoritesCoordinator.rootViewController]
    }
}
