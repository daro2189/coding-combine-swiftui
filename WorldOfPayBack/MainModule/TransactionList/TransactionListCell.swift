//
//  TransactionListCell.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import SwiftUI

struct TransactionListCell: View {

    // MARK: - Properties & Dependencies

    var transaction: TransactionModel

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(transaction.partnerDisplayName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .lineLimit(2)

                HStack(spacing: 5) {
                    Text("\(transaction.transactionDetail.value.amount)")
                        .frame(alignment: .trailing)
                        .foregroundColor(.gray)

                    Text(transaction.transactionDetail.value.currency)
                        .frame(alignment: .leading)
                        .foregroundColor(.gray)
                }
            }

            Text(transaction.date)
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(transaction.contentDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }
}

struct TransactionListCell_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListCell(transaction: TransactionModel.fixture())
    }
}
