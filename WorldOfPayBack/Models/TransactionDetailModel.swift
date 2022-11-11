//
//  asdf.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 11/11/2022.
//

import Foundation

struct TransactionDetailModel: Decodable {

    // MARK: - Properties & Dependencies
    
    var contentDescription: String?
    var bookingDate: Date
    var value: ValueModel

    enum CodingKeys: String, CodingKey {
        case value, bookingDate
        case contentDescription = "description"
    }

    // MARK: - Initializers

    init(contentDescription: String?, bookingDate: Date, value: ValueModel) {
        self.contentDescription = contentDescription
        self.bookingDate = bookingDate
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let desc = try? values.decode(String.self, forKey: .contentDescription) {
            contentDescription = desc
        } else {
            contentDescription = ""
        }
        value = try values.decode(ValueModel.self, forKey: .value)

        let dateString = try values.decode(String.self, forKey: .bookingDate)
        if let date = dateString.toDate() {
            bookingDate = date
        } else {
            bookingDate = Date()
        }
    }
}
