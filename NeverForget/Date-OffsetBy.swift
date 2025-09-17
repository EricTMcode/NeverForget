//
//  Date-OffsetBy.swift
//  NeverForget
//
//  Created by Eric on 17/09/2025.
//

import Foundation

extension Date {
    func offsetBy(days: Int, seconds: Int) -> Date {
        var components = DateComponents()
        components.day = days
        components.second = seconds
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }
}
