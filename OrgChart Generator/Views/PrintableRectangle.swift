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


struct PrintableRectangle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrintableRectangle(color: .systemBlue)
                .previewLayout(.fixed(width: 100, height: 100))
        }
    }
}
