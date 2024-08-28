//
//  File.swift
//
//
//  Created by jvic on 28/08/24.
//

import Foundation
import UIKit

open class NetworkUtil {
    public static func fetchImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}
