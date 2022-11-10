//
//  PhysicCategory.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import Foundation


enum PhysicCategory {
    static let winPoint:UInt32 = 0x1 << 0
    static let ball: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let border: UInt32 = 0x1 << 3
    static let upGroudn: UInt32 = 0x1 << 4
    static let upGroudn1: UInt32 = 0x1 << 5
}
