//
//  TransactionListView.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import SwiftUI

struct TransactionListView: View {
    private enum Constants {
        static let defaultEdges = EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
    }

    // MARK: - Properties & Dependencies

    @StateObject var viewModel: TransactionListViewModel

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(LocalizedStringKey("transaction-list-view-category-filter"))
                    Picker(selection: $viewModel.selectionIndex, label: Text(LocalizedStringKey("transaction_list_view_category_filter"))) {
                        Text(LocalizedStringKey("transaction-list-view-none")).tag(-1)
                        ForEach(viewModel.categoryFilter) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Constants.defaultEdges)

                if viewModel.isLoading {
                    TransactionLoadingView()

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

                HStack {
                    Text(LocalizedStringKey("transaction-list-view-total"))
                        .frame(alignment: .trailing)
                    Text(viewModel.totalCalculatedPrice)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(Constants.defaultEdges)

                if !viewModel.isInternet {
                    Text(LocalizedStringKey("transaction-list-view-no-internet-connection"))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(.red)
                }
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
