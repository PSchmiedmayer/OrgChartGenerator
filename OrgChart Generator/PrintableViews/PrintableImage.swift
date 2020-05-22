//
//  PrintableImage.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI

enum ImageDisplayMode {
    case scaleToFill
    case scaleToFit
}

struct PrintableImage: View {
    var image: NSImage
    var mode: ImageDisplayMode = .scaleToFill

    var body: some View {
        DrawableView { rect in
            let imageAspectRatio = self.image.size.height / self.image.size.width
            let viewAspectRatio = rect.size.height / rect.size.width

            if (self.mode == .scaleToFill && imageAspectRatio > viewAspectRatio) ||
               (self.mode == .scaleToFit && imageAspectRatio < viewAspectRatio) {
                self.image.size.width = rect.size.width
                self.image.size.height = rect.size.width * imageAspectRatio
            } else {
                self.image.size.width = rect.size.height / imageAspectRatio
                self.image.size.height = rect.size.height
            }
            
            let imageOrigin = CGPoint(x: (self.image.size.width - rect.size.width) / 2,
                                      y: (self.image.size.height - rect.size.height) / 2)
            self.image.draw(in: rect,
                            from: CGRect(origin: imageOrigin,
                                         size: rect.size),
                            operation: .copy,
                            fraction: 1.0)
        }
    }
}
