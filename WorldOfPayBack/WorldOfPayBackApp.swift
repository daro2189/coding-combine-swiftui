//
//  WorldOfPayBackApp.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import SwiftUI

@main
struct WorldOfPayBackApp: App {

    init() {
#if PRODUCTION
        print("IS PRODUCTION APP")
#else
        print("IS DEVELOP APP")
#endif
    }

    var body: some Scene {
        WindowGroup {
            let viewModel = TransactionListViewModel(
                transactionService: TransactionServiceImpl(
                    apiService: APIFakeService()
                )
            )
            TransactionListView(viewModel: viewModel)
        }
    }
}
