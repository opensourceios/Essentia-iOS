//
//  UIView+Gradient.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/20/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum GradientType {
    case leftToRight
    case topToBottom
    
    var startPoint: CGPoint {
        switch self {
        case .leftToRight:
            return CGPoint(x: 0.0, y: 1.0)
        case .topToBottom:
            return CGPoint(x: 1.0, y: 0.0)
        }
    }
    
    var endPoint: CGPoint {
        switch self {
        case .leftToRight:
            return CGPoint(x: 1.0, y: 1.0)
        case .topToBottom:
            return CGPoint(x: 1.1, y: 1.0)
        }
    }
}

extension UIView {
    func setGradientBackground(first: UIColor, second: UIColor, type: GradientType) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [first.cgColor, second.cgColor]
        layer.addSublayer(gradientLayer)
    }
}
