//
//  TransactionLoadingView.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 11/11/2022.
//

import SwiftUI

struct TransactionLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView(LocalizedStringKey("transaction-list-view-please-wait-loading"))
            Spacer()
        }
    }
}
