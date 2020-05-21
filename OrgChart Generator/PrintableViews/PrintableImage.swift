//
//  PrintableImage.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct PrintableImage: View {
    var image: NSImage

    var body: some View {
        DrawableView { rect in
            let imageAspectRatio = self.image.size.height / self.image.size.width
            let viewAspectRatio = rect.size.height / rect.size.width

            if imageAspectRatio > viewAspectRatio {
                self.image.size.width = rect.size.width
                self.image.size.height = rect.size.width * imageAspectRatio
            } else {
                self.image.size.width = rect.size.height / imageAspectRatio
                self.image.size.height = rect.size.height
            }
            
            self.image.draw(in: rect,
                            from: CGRect(origin: CGPoint(x: (self.image.size.width - rect.size.width) / 2,
                                                         y: (self.image.size.height - rect.size.height) / 2),
                                         size: rect.size),
                            operation: .copy,
                            fraction: 1.0)
        }
    }
}
