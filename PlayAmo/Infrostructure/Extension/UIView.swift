//
//  UIView.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 08.11.2022.
//

import UIKit

extension UIView {
    
    enum GlowEffect: Float {
        case small = 0.4, normal = 7, big = 15
    }
    
    func doGlowAnimation(withColor color: UIColor, withEffect effect: GlowEffect = .normal) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = .zero
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
    
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = Int.zero
        glowAnimation.toValue = effect.rawValue
        glowAnimation.beginTime = CACurrentMediaTime()+0.3
        glowAnimation.duration = CFTimeInterval(0.3)
        glowAnimation.fillMode = .removed
        glowAnimation.autoreverses = true
        glowAnimation.isRemovedOnCompletion = true
        glowAnimation.repeatCount  = .infinity
        layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
    
    func removeGlowAnimation() {
        layer.removeAnimation(forKey: "shadowGlowingAnimation")
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5,
                                                       y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5,
                                                     y: center.y))

        layer.add(animation, forKey: "shaking")
    }
    
    func animatePulse() {
        let widthAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        widthAnimation.values = [1.05, 0.95, 1.05]
        widthAnimation.keyTimes = [0, 0.5, 1]
        widthAnimation.repeatCount = .infinity
        widthAnimation.duration = 0.5
//        widthAnimation
        layer.add(widthAnimation, forKey: "scaleAnimation")
    }
    
    func removeShakingAnimation() {
        layer.removeAnimation(forKey: "shaking")
    }
}



