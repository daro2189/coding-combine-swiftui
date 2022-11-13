//
//  APIServiceMock.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import UIKit
import Combine

final class APIFakeService: APIService {

    // MARK: - API Methods

    func getTransactions() -> AnyPublisher<[TransactionModel], Error> {
        if isSuccess() {
            let transactionListModel: TransactionListModel = Bundle.main.decode("PBTransactions.json")
            return Just<[TransactionModel]>(transactionListModel.items)
                .setFailureType(to: Error.self)
                .delay(for: .milliseconds(Int.random(in: 500..<2000)), scheduler: DispatchQueue.global())
                .eraseToAnyPublisher()
        }
        return Fail(error: API.Error.invalidResponse)
            .delay(for: .milliseconds(Int.random(in: 500..<2000)), scheduler: DispatchQueue.global())
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers

    private func isSuccess() -> Bool {
        let randomInt = Int.random(in: 1..<100)
        if randomInt < 15 {
            return false
        }
        return true
    }
}
