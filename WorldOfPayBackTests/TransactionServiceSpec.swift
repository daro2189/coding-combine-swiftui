//
//  WorldOfPayBackTests.swift
//  WorldOfPayBackTests
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import Quick
import Nimble
import Combine
import Foundation
@testable import WorldOfPayBack

class TransactionServiceSpec: QuickSpec {

    override func spec() {
        describe("TransactionService") {
            var sut: TransactionService!
            var apiServiceMock: APIServiceMock!
            var disposable = Set<AnyCancellable>()

            beforeEach {
                apiServiceMock = APIServiceMock()
                sut = TransactionServiceImpl(apiService: apiServiceMock)
            }

            describe("fetchList") {
                context("when there is an error") {
                    beforeEach {
                        apiServiceMock.isSuccess = false
                    }

                    it("should return error") {
                        var isError = false
                        sut.fetchList().sink { completition in
                            switch completition {
                            case .failure:
                                isError = true
                            case .finished:
                                break
                            }
                        } receiveValue: { transactions in }
                        .store(in: &disposable)

                        expect(isError).toEventually(beTrue())
                    }
                }

                context("when there is an transaction list") {
                    beforeEach {
                        apiServiceMock.isSuccess = true
                    }

                    it("should have transactions") {
                        var transactionList: [TransactionModel] = []
                        sut.fetchList().sink { completition in
                        } receiveValue: { transactions in
                            transactionList = transactions
                        }
                        .store(in: &disposable)

                        expect(transactionList.count == 21).toEventually(beTrue())
                    }
                }
            }
        }
    }
}

final class APIServiceMock: APIService {

    var isSuccess: Bool?
    func getTransactions() -> AnyPublisher<[TransactionModel], Error> {
        if let isSuccess = isSuccess, isSuccess {
            let transactionListModel: TransactionListModel = Bundle.main.decode("PBTransactions.json")
            return Just<[TransactionModel]>(transactionListModel.items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: API.Error.invalidResponse)
            .eraseToAnyPublisher()
    }
}
