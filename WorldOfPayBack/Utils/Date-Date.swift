//
//  Date-Date.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import Foundation

extension Date {
    public func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
