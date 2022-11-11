//
//  CategoryPickerView.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 11/11/2022.
//

import SwiftUI

struct CategoryPickerView: View {
    @Binding var selectedIndex: Int
    private(set) var categoryFilter: [TransactionListViewModel.Category]

    var body: some View {
        HStack {
            Text(LocalizedStringKey("transaction-list-view-category-filter"))
            Picker(selection: $selectedIndex, label: Text(LocalizedStringKey("transaction_list_view_category_filter"))) {
                Text(LocalizedStringKey("transaction-list-view-none")).tag(-1)
                ForEach(categoryFilter) { category in
                    Text(category.name).tag(category.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}
