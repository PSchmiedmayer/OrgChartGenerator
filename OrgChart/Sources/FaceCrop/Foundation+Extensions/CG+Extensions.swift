//
//  CG+Extension.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x - size.width/2.0,
                                  y: center.y - size.height/2.0),
                  size: size)
    }
    
    init(center: CGPoint, size: CGFloat) {
        self.init(center: center,
                  size: CGSize(width: size, height: size))
    }
    
    var center: CGPoint {
        get {
            return self.origin + self.size / CGFloat(2.0)
        }
        set {
            self.origin = CGPoint(x: newValue.x - size.width/2.0,
                                  y: newValue.y - size.height/2.0)
        }
    }
}

extension CGPoint {
    init(fromSize size: CGSize) {
        self.init(x: size.width, y: size.width)
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func + (lhs: CGSize, rhs: CGPoint) -> CGPoint {
        return CGPoint(fromSize: lhs) + rhs
    }
    
    static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return rhs + lhs
    }
}

extension CGSize {
    static func * (size: CGSize, scale: CGVector) -> CGSize {
        return CGSize(width: size.width * scale.dx, height: size.height * scale.dy)
    }
    
    static func * (size: CGSize, scale: CGFloat) -> CGSize {
        return size * CGVector(dx: scale, dy: scale)
    }
    
    static func / (size: CGSize, scale: CGVector) -> CGSize {
        return size * CGVector(dx: 1.0/scale.dx, dy: 1.0/scale.dy)
    }
    
    static func / (size: CGSize, scale: CGFloat) -> CGSize {
        return size * (1.0/scale)
    }
}
