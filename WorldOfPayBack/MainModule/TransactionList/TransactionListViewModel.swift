//
//  TransactionListViewModel.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import Combine
import SwiftUI
import Connectivity

@MainActor protocol TransactionListViewModelProtocole {
    var filteredTransactions: [TransactionModel] { get }
    var calculatedPrice: Int { get }
    var totalCalculatedPrice: String { get }
    var isTransactionListEmpty: Bool { get }

    func loadTransactions()
}

@MainActor final class TransactionListViewModel: ObservableObject, TransactionListViewModelProtocole {

    struct Category: Identifiable, Hashable {
        var id: Int
        var name: String
    }

    // MARK: - Properties & Dependencies

    var filteredTransactions: [TransactionModel] {
        if let selectedCategory = selectedCategory {
            return transactionList
                .filter { transactionModel in
                    transactionModel.category == selectedCategory
                }
        }
        return transactionList
    }

    var calculatedPrice: Int {
        filteredTransactions.reduce(0, { $0 + $1.transactionDetail.value.amount })
    }

    var totalCalculatedPrice: String {
        "\(calculatedPrice) \(filteredTransactions.first?.transactionDetail.value.currency ?? "")"
    }

    var isTransactionListEmpty: Bool {
        filteredTransactions.isEmpty
    }

    @Published var selectionIndex: Int = -1
    @Published var isError = false
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var isInternet = true

    private var transactionList: [TransactionModel] = []
    private(set) var categoryFilter: [Category] = []
    private var disposables = Set<AnyCancellable>()
    private let transactionService: TransactionService

    private var selectedCategory: Int? {
        return categoryFilter.first { category in
            category.id == selectionIndex
        }?.id ?? nil
    }

    // MARK: - Initializers

    init(transactionService: TransactionService) {
        self.transactionService = transactionService

        loadTransactions()
        startNetworkListening()
    }

    // MARK: - Functions

    func loadTransactions() {
        isLoading = true
        transactionService
            .fetchList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                self.isLoading = false

                switch value {
                case .finished:
                    break
                case .failure(let error):
                    self.showError(error: error)
                }
            }, receiveValue: { [weak self] transactions in
                guard let self = self else { return }

                self.transactionList = transactions
                    .sorted { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate }
                self.assignCategoriesFilter(transactions: transactions)
            })
            .store(in: &disposables)
    }

    // MARK: - Helpers

    private func assignCategoriesFilter(transactions: [TransactionModel]) {
        let categorySet = Set<Category>(transactions.map({ transactionModel in
            Category(id: transactionModel.category, name: "\("transaction-list-view-model-categorie".localized) \(transactionModel.category)")
        }))
        categoryFilter = Array(categorySet)
            .sorted(by: { $0.id < $1.id })
    }

    private func showError(error: Error) {
        isError = true
        if let error = error as? API.Error, let errorMsg = error.errorDescription {
            errorMessage = errorMsg
        } else {
            errorMessage = error.localizedDescription
        }
    }

    private func startNetworkListening() {
        Connectivity.Publisher(
            configuration: .init()
                .configureURLSession(.default)
                .configurePolling(isEnabled: true, interval: 5, offlineOnly: true)
        )
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connectivity in
                switch connectivity.status {
                case .connectedViaWiFi, .connectedViaCellular, .connected, .connectedViaEthernet:
                    self?.isInternet = true
                default:
                    self?.isInternet = false
                }
            }
            .store(in: &disposables)
    }
}
