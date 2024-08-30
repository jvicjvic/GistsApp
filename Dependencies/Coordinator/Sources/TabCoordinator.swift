//
//  TabCoordinator.swift
//  GistsApp
//
//  Created by jvic on 30/08/24.
//

import Foundation
import UIKit

public protocol TabCoordinator: Coordinator {
    var rootViewController: UITabBarController { get set }
    var childCoordinators: [Coordinator] { get set }
}
