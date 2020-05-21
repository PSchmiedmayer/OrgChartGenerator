//
//  PrintableBorder.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct PrintableBorder: View {
    @State var color: NSColor
    @State var width: CGFloat


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


struct PrintableBorder_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrintableBorder(color: .systemRed, width: 3)
        }.previewLayout(.fixed(width: 100, height: 100))
    }
}
