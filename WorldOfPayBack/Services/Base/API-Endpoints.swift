//
//  APIEndpoints.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import Foundation

struct API {
    static let baseURL = {
        #if PRODUCTION
        URL(string: "https://api.payback.com/")!
        #else
        URL(string: "https://api-test.payback.com/")!
        #endif
    }()

    enum EndPoint {
        case transactionList

        var url: URL {
            switch self {
            case .transactionList:
                return API.baseURL.appendingPathComponent("transactions")
            }
        }
    }
}
