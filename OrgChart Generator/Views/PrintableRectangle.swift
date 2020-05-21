//
//  PrintableRectangle.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI

struct PrintableRectangle: View {
    @State
    var color: NSColor

    var body: some View {
        DrawableView { rect in
            self.color.setFill()
            rect.fill()
        }
    }
}

fileprivate struct PrintableRectangleModifer: ViewModifier {
    fileprivate enum Defaults {
        static let allignment: Alignment = .center
    }
    
    fileprivate let color: NSColor
    fileprivate let allignment: Alignment
    
    
    fileprivate init(color: NSColor, allignment: Alignment = Defaults.allignment) {
        self.color = color
        self.allignment = allignment
    }
    

    func body(content: Content) -> some View {
        content
            .background(PrintableRectangle(color: color),
                        alignment: allignment)
    }
}

extension View {
    func printableBackground(_ color: NSColor,
                             allignment: Alignment = PrintableRectangleModifer.Defaults.allignment) -> some View {
        self.modifier(PrintableRectangleModifer(color: color, allignment: allignment))
    }
}


struct PrintableRectangle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrintableRectangle(color: .systemBlue)
                .previewLayout(.fixed(width: 100, height: 100))
        }
    }
}
