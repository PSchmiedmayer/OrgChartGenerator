//
//  File.swift
//  
//
//  Created by Paul Schmiedmayer on 5/19/20.
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

struct PrintableRectangleModifer: ViewModifier {
    let color: NSColor
    
    func body(content: Content) -> some View {
        content
            .background(PrintableRectangle(color: color))
    }
}

extension View {
    func printableBackground(_ color: NSColor) -> some View {
        self.modifier(PrintableRectangleModifer(color: color))
    }
}
