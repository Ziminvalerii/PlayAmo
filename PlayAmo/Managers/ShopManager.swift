//
//  ShopManager.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 07.11.2022.
//

import Foundation
import SpriteKit


class ShopManager {
    
    enum Key {
        static let selectedBall = "selected_ball"
        static let selectedCup = "selected_cup"
        static let selectedTable = "selected_table"
        static let boughtBallIndex = "boughtBallIndex"
        static let boughtCupIndex = "boughtCupIndex"
        static let boughtTableIndex = "boughtTableIndex"
    }
    
    //
    //    static var products: [String:Any] {
    //        return ["balls" : Ball.allCases, "tables" : Table.allCases, "cups" : Cup.allCases]
    //    }
    
    static var products: [Product] {
        var products = [Product]()
        products.append(contentsOf: Ball.allCases)
        products.append(contentsOf: Table.allCases)
        products.append(contentsOf: Cup.allCases)
        return products
    }
    
    
    static var boughtBallIndex: [Int]? {
        get {
            UserDefaults.standard.object(forKey: Key.boughtBallIndex) as? [Int]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.boughtBallIndex)
        }
    }
    
    static var boughtCupIndex: [Int]? {
        get {
            UserDefaults.standard.object(forKey: Key.boughtCupIndex) as? [Int]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.boughtCupIndex)
        }
    }
    
    static var boughtTableIndex: [Int]? {
        get {
            UserDefaults.standard.object(forKey: Key.boughtTableIndex) as? [Int]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.boughtTableIndex)
        }
    }
    
    static var selectedBallIndex: Int {
        get {
            UserDefaults.standard.integer(forKey: Key.selectedBall)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.selectedBall)
        }
    }
    
    static var selectedCupIndex: Int {
        get {
            UserDefaults.standard.integer(forKey: Key.selectedCup)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.selectedCup)
        }
    }
    
    static var selectedTableIndex: Int {
        get {
            UserDefaults.standard.integer(forKey: Key.selectedTable)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.selectedTable)
        }
    }
    
    static var selectedModel: TenissModel {
        let balls = Ball.allCases
        let table = Table.allCases
        let cup = Cup.allCases
        return TenissModel(ball: balls[selectedBallIndex], table: table[selectedTableIndex], cup: cup[selectedBallIndex])
    }
    
}


struct TenissModel {
    public let ball: Ball
    public let table: Table
    public let cup: Cup
}


enum Ball: Int, CaseIterable, Product {
    case whiteBall = 0
    case orangeBall = 1
    case blueBall = 2
    
    var texture : SKTexture {
        return SKTexture(imageNamed: "ball\(self.rawValue)")
    }
    
    var image : UIImage {
        return UIImage(named: "ball\(self.rawValue)")!
    }
    
    var price: Int {
        switch self {
        case .whiteBall:
            return 0
        case .orangeBall:
            return 100
        case .blueBall:
            return 200
        }
    }
}
enum Table: Int, CaseIterable, Product {
    case greenTable = 0
    case blueTable = 1
    case purpleTable = 2
    
    var texture: SKTexture {
        return SKTexture(imageNamed: "tenisTable\(self.rawValue)")
    }
    var image : UIImage {
        return UIImage(named: "tenisTable\(self.rawValue)")!
    }
    var price: Int {
        switch self {
        case .greenTable:
            return 0
        case .blueTable:
            return 500
        case .purpleTable:
            return 1000
        }
    }
}

enum Cup: Int, CaseIterable, Product {
    var image: UIImage {
        return UIImage(named: "shopCup\(self.rawValue)")!
    }
    
    var price: Int {
        switch self {
        case .redCup:
            return 0
        case .greenCup:
            return 250
        case .purpleCup:
            return 500
        }
    }
    
    case redCup = 0
    case greenCup = 1
    case purpleCup = 2
    
    //    var image: UIImage {
    //        return UIImage(named: "shopCup\(self.rawValue)")!
    //    }
    
    var middleTexture: SKTexture {
        return SKTexture(imageNamed: "middlecup\(self.rawValue)")
    }
    
    var texture:SKTexture {
        return SKTexture(imageNamed: "cup\(self.rawValue)")
    }

}

protocol Product {
    var image : UIImage {get}
    var price:Int {get}
}
