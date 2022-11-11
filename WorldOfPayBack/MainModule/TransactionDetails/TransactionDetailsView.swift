//
//  TransactionDetailsView.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import SwiftUI

struct TransactionDetailsView: View {

    // MARK: - Properties & Dependencies

    let displayName: String
    let date: String
    let contentDescription: String

    // MARK: - View

    var body: some View {
        VStack {
            Text(displayName)
                .font(.title)
            Text(date)
                .font(.subheadline)
            Divider()

            Text(contentDescription)
                .font(.headline)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding()
        .navigationBarTitle(Text(displayName), displayMode: .inline)
    }
}

struct TransactionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailsView(
            displayName: "Some Displa Name",
            date: "12 Jan 2021",
            contentDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        )
    }
}
