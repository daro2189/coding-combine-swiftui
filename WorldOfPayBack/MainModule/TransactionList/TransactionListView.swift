//
//  TransactionListView.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import SwiftUI

struct TransactionListView: View {

    // MARK: - Properties & Dependencies

    @ObservedObject var viewModel: TransactionListViewModel

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack {
                CategoryPickerView(
                    selectedIndex: $viewModel.selectionIndex,
                    categoryFilter: viewModel.categoryFilter
                )

                if viewModel.isLoading {
                    LoadingListView()

                } else {
                    if viewModel.isTransactionListEmpty {
                        VStack {
                            Spacer()
                            Text(LocalizedStringKey("transaction-list-view-no-data-available"))
                                .padding(10)
                            Button(LocalizedStringKey("transaction-list-view-reload-data")) {
                                viewModel.loadTransactions()
                            }
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(viewModel.filteredTransactions) { item in
                                NavigationLink {
                                    TransactionDetailsView(
                                        displayName: item.partnerDisplayName,
                                        date: item.date,
                                        contentDescription: item.contentDescription
                                    )
                                } label: {
                                    TransactionListCell(transaction: item)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }

                TotalAmountView(totalCalculatedPrice: viewModel.totalCalculatedPrice)
                NoInternetView(isInternetConnection: viewModel.isInternet)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(LocalizedStringKey("transaction-list-view-transactions"))
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.isError, actions: {
            Button(LocalizedStringKey("OK")) { }
            Button(LocalizedStringKey("transaction-list-view-try-again"), role: .cancel) {
                viewModel.loadTransactions()
            }
        })
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TransactionListViewModel(
            transactionService: TransactionServiceImpl(
                apiService: APIFakeService()
            )
        )
        return TransactionListView(viewModel: viewModel)
            .previewLayout(.device)
            .previewDevice("iPhone 13 Pro")
    }
}
