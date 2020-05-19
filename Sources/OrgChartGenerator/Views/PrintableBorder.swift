//
//  File.swift
//  
//
//  Created by Paul Schmiedmayer on 5/19/20.
//

import SwiftUI


struct PrintableBorder: View {
    @State
    var color: NSColor
    
    @State
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

struct PrintableBorderModifer: ViewModifier {
    var color: NSColor
    var width: CGFloat
    @State var test: CGSize = .zero
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        print(geometry.size)
                        self.test = geometry.size
                    }
                })
            PrintableBorder(color: self.color, width: self.width)
                .frame(width: test.width, height: test.height)
        }
    }
}

extension View {
    func printableBorder(_ color: NSColor, width: CGFloat = 1) -> some View {
        self.modifier(PrintableBorderModifer(color: color, width: width))
    }
}
