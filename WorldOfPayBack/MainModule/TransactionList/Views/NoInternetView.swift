//
//  NoInternetView.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 11/11/2022.
//

import SwiftUI

struct NoInternetView: View {
    private(set) var isInternetConnection: Bool

    var body: some View {
        if !isInternetConnection {
            Text(LocalizedStringKey("transaction-list-view-no-internet-connection"))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.red)
        }
    }
}
