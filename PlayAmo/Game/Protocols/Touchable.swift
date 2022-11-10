//
//  Touchable.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import UIKit


protocol Touchable : AnyObject {
    var shouldAcceptTouches: Bool { get set }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
}

extension Touchable {
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)  {}
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)  {}
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {}
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)  {}
}
