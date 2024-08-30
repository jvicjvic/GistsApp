//
//  ApplicationCoordinator.swift
//  GistsApp
//
//  Created by jvic on 30/08/24.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()

    init(window: UIWindow) {
        self.window = window
    }

    @MainActor func start() {
        let mainCoordinator = MainTabCoordinator()
        mainCoordinator.start()
        window.rootViewController = mainCoordinator.rootViewController
        childCoordinators = [mainCoordinator]
        window.backgroundColor = .white
    }
}
