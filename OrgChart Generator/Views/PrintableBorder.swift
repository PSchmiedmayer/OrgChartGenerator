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
            print(rect)

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

struct PrintableBorderModifer: ViewModifier {
    var color: NSColor
    var width: CGFloat
    @State var size: CGSize = CGSize(width: 100, height: 100)

    func body(content: Content) -> some View {
        ZStack {
            content
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        self.size = geometry.size
                    }
                })
            PrintableBorder(color: self.color, width: self.width)
                .frame(width: size.width, height: size.height)
        }
    }
}

extension View {
    func printableBorder(_ color: NSColor, width: CGFloat = 1) -> some View {
        self.modifier(PrintableBorderModifer(color: color, width: width))
    }
}



struct PrintableBorder_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrintableBorder(color: .systemRed, width: 3)
            Rectangle()
                .frame(width: 10, height: 10)
                .printableBorder(.systemRed, width: 4)
            Text("A Test")
                .printableBorder(.systemRed, width: 5)
        }.previewLayout(.fixed(width: 100, height: 100))
    }
}
