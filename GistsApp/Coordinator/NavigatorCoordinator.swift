//
//  NavigatorCoordinator.swift
//  GistsApp
//
//  Created by jvic on 30/08/24.
//

import Foundation
import UIKit

protocol NavigatorCoordinator: Coordinator {
    var rootViewController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
}

