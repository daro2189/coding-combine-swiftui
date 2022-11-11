//
//  APIService.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import Foundation
import Combine

protocol APIService {
    func getTransactions() -> AnyPublisher<[TransactionModel], Error>
}

final class APIServiceImpl: APIService {

    // MARK: - API Methods

    func getTransactions() -> AnyPublisher<[TransactionModel], Error> {
        request(endpoint: .transactionList, ofType: TransactionListModel.self)
            .tryMap { model in
                model.items
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers

    private func request<T: Decodable>(endpoint: API.EndPoint, ofType: T.Type) -> AnyPublisher<T, API.Error> {
        URLSession.shared
            .dataTaskPublisher(for: endpoint.url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                guard element.data.count > 0 else {
                    throw URLError(.zeroByteResource)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError({ error in
                switch error {
                case is URLError:
                    return API.Error.addressUnreachable(endpoint.url)
                default:
                    return API.Error.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
}
