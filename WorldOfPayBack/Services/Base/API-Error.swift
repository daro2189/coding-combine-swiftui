//
//  API-Error.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 11/11/2022.
//

import Foundation
import SwiftUI

extension API {
    enum Error: LocalizedError {
        case addressUnreachable(URL)
        case invalidResponse

        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "api-error-invalid-response-from-the-server".localized
            case .addressUnreachable(let url):
                return "\("api-error-unreachable-url".localized) \(url.absoluteString)"
            }
        }
    }
}
