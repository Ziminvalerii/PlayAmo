//
//  Data.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 08.11.2022.
//

import Foundation


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
