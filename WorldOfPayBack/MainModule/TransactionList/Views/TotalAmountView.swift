//
//  TotalAmountView.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 11/11/2022.
//

import SwiftUI

struct TotalAmountView: View {
    private(set) var totalCalculatedPrice: String

    var body: some View {
        HStack {
            Text(LocalizedStringKey("transaction-list-view-total"))
                .frame(alignment: .trailing)
            Text(totalCalculatedPrice)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}
