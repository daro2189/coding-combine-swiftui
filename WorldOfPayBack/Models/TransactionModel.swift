//
//  Transaction.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import Foundation

struct TransactionModel: Decodable, Identifiable {

    // MARK: - Properties & Dependencies
    
    var id: String
    var partnerDisplayName: String
    var category: Int
    var alias: AliasModel
    var transactionDetail: TransactionDetailModel

    var contentDescription: String {
        transactionDetail.contentDescription ?? ""
    }

    var date: String {
        transactionDetail.bookingDate.formatted()
    }

    enum CodingKeys: String, CodingKey {
        case partnerDisplayName, category, transactionDetail, alias
    }

    // MARK: - Initializers

    init(id: String, partnerDisplayName: String, category: Int, transactionDetail: TransactionDetailModel, alias: AliasModel) {
        self.id = id
        self.partnerDisplayName = partnerDisplayName
        self.category = category
        self.transactionDetail = transactionDetail
        self.alias = alias
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        partnerDisplayName = try values.decode(String.self, forKey: .partnerDisplayName)
        category = try values.decode(Int.self, forKey: .category)
        transactionDetail = try values.decode(TransactionDetailModel.self, forKey: .transactionDetail)
        alias = try values.decode(AliasModel.self, forKey: .alias)

        id = alias.reference
    }
}

extension TransactionModel {
    public static func fixture(
        id: String = "unique",
        partnerDisplayName: String = "Test1",
        category: Int = 1
    ) -> TransactionModel {
        TransactionModel(
            id: id,
            partnerDisplayName: partnerDisplayName,
            category: category,
            transactionDetail: TransactionDetailModel(
                contentDescription: "some desc",
                bookingDate: Date(),
                value: ValueModel(
                    amount: 53,
                    currency: "GBP"
                )
            ),
            alias: AliasModel(reference: "235tsddfg")
        )
    }
}
