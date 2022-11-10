//
//  Defaults.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 08.11.2022.
//

import Foundation


class Defaults {
    enum Key {
        static let coinsCount = "coins_coins"
        static let dailyBonusDate = "dailyBonusDate"
        static let stake = "current_stake"
    }
    
    static var stake: Int {
        get {
            return UserDefaults.standard.integer(forKey: Key.stake)
        } set {
            return UserDefaults.standard.set(newValue, forKey: Key.stake)
        }
    }
    
    static var dailyBonusDate: Date? {
        get {
            UserDefaults.standard.value(forKey: Key.dailyBonusDate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.dailyBonusDate)
        }
    }
    
    static var coinsCount: Int? {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.coinsCount)
        }
        get {
            UserDefaults.standard.object(forKey: Key.coinsCount) as? Int
        }
    }
}
