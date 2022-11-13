//
//  TransactionService.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import Combine

//sourcery: AutoMockable
protocol TransactionService {
    func fetchList() -> AnyPublisher<[TransactionModel], Error>
}

final class TransactionServiceImpl: TransactionService {

    // MARK: - Properties & Dependencies

    private let apiService: APIService
    private var disposable = Set<AnyCancellable>()

    // MARK: - Initializers

    init(apiService: APIService) {
        self.apiService = apiService
    }

    // MARK: - Functions

    func fetchList() -> AnyPublisher<[TransactionModel], Error> {
        Deferred {
            Future { [weak self] handler in
                guard let self = self else { return }

                self.apiService
                    .getTransactions()
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            handler(.failure(error))
                        default:
                            break
                        }
                    }, receiveValue: { transactions in
                        handler(.success(transactions))
                    })
                    .store(in: &self.disposable)
            }
        }
        .eraseToAnyPublisher()
    }
}
