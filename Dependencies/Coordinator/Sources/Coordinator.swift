//
//  Coordinator.swift
//  GistsApp
//
//  Created by jvic on 30/08/24.
//

import Foundation

public protocol Coordinator {
    @MainActor func start()
}
