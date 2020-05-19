//
//  DrawableView.swift
//  
//
//  Created by Paul Schmiedmayer on 5/19/20.
//

import SwiftUI


struct DrawableView: NSViewRepresentable {
    class ColorView: NSView {
        let drawFunction: (NSRect) -> ()
        
        init(_ draw: @escaping (NSRect) -> ()) {
            self.drawFunction = draw
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func draw(_ dirtyRect: NSRect) {
            super.draw(dirtyRect)
            self.drawFunction(dirtyRect)
        }
    }
    
    
    let draw: (NSRect) -> ()
    
    init(_ draw: @escaping (NSRect) -> ()) {
        self.draw = draw
    }
    
    
    func makeNSView(context: Context) -> ColorView {
        ColorView(draw)
    }
    
    func updateNSView(_ colorView: ColorView, context: Context) {
        colorView.setNeedsDisplay(colorView.frame)
    }
}
