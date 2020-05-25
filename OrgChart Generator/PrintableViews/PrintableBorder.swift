//
//  PrintableBorder.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct PrintableBorder: View {
    var color: NSColor
    var width: CGFloat


    var body: some View {
        DrawableView { rect in
            guard rect.size.width > self.width, rect.size.height > self.width else {
                if rect.size.width == self.width || rect.size.height == self.width {
                    self.color.setFill()
                    rect.fill()
                }

                return
            }

            let border = NSRect(x: self.width / 2,
                                y: self.width / 2,
                                width: rect.size.width - self.width,
                                height: rect.size.height - self.width)

            let borderPath = NSBezierPath(rect: border)
            borderPath.lineWidth = self.width
            self.color.set()
            borderPath.stroke()
        }
    }
}


fileprivate struct PrintableBorderModifer: ViewModifier {
    fileprivate enum Defaults {
        static let width: CGFloat = 1
        static let allignment: Alignment = .center
    }
    
    fileprivate let color: NSColor
    fileprivate let width: CGFloat
    fileprivate let allignment: Alignment
    
    init(color: NSColor, width: CGFloat, allignment: Alignment = Defaults.allignment) {
        self.color = color
        self.width = width
        self.allignment = allignment
    }

    func body(content: Content) -> some View {
        content
            .overlay(PrintableBorder(color: self.color, width: self.width),
                     alignment: allignment)
    }
}


extension View {
    func printableBorder(_ color: NSColor,
                         width: CGFloat = PrintableBorderModifer.Defaults.width,
                         allignment: Alignment = PrintableBorderModifer.Defaults.allignment) -> some View {
        self.modifier(PrintableBorderModifer(color: color, width: width, allignment: allignment))
    }
}


struct PrintableBorder_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrintableBorder(color: .systemRed, width: 3)
            Rectangle()
                .frame(width: 30, height: 100)
                .printableBorder(.systemRed, width: 4)
            Text("A Test")
                .printableBorder(.systemRed, width: 5)
        }.previewLayout(.fixed(width: 100, height: 100))
    }
}
