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
    @Binding var imageState: ImageState
    @State var mode: ImageDisplayMode = .scaleToFill

    var body: some View {
        DrawableView { rect in
            guard let image = self.imageState.image else {
                return
            }
            
            let imageAspectRatio = image.size.height / image.size.width
            let viewAspectRatio = rect.size.height / rect.size.width

            if (self.mode == .scaleToFill && imageAspectRatio > viewAspectRatio) ||
               (self.mode == .scaleToFit && imageAspectRatio < viewAspectRatio) {
                image.size.width = rect.size.width
                image.size.height = rect.size.width * imageAspectRatio
            } else {
                image.size.width = rect.size.height / imageAspectRatio
                image.size.height = rect.size.height
            }
            
            let imageOrigin = CGPoint(x: (image.size.width - rect.size.width) / 2,
                                      y: (image.size.height - rect.size.height) / 2)
            image.draw(in: rect,
                       from: CGRect(origin: imageOrigin,
                                    size: rect.size),
                       operation: .copy,
                       fraction: 1.0)
        }
    }
}
