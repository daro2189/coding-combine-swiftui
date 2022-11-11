//
//  String-Date.swift
//  WorldOfPayBack
//
//  Created by Dariusz Mazur on 10/11/2022.
//

import Foundation

extension String {
    public func toDate() -> Date? {
        let localISOFormatter = ISO8601DateFormatter()
        localISOFormatter.timeZone = TimeZone.current
        return localISOFormatter.date(from: self)
    }
}
