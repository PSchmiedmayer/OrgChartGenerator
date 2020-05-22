//
//  LoadableImageView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart

struct LoadableImageView: View {
    var imagePath: URL
    var displayMode: ImageDisplayMode = .scaleToFill
    @State private var image: NSImage?
    @State private var loading: Bool = true
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            if image == nil {
                Rectangle()
                    .foregroundColor(Color(.lightGray))
            }
            ActivityIndicator(loading: $loading)
            errorMessage.map { errorMessage in
                Text(errorMessage)
                    .multilineTextAlignment(.center)
            }
            self.image.map { image in
                PrintableImage(image: image, mode: displayMode)
            }
        }.onAppear(perform: self.loadImage)
    }
    
    func loadImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: self.imagePath),
                  let image = NSImage(data: data) else {
                DispatchQueue.main.async {
                    self.errorMessage = """
                        ⚠️
                        Could not be loaded
                    """
                    self.loading = false
                }
                return
            }
            DispatchQueue.main.async {
                self.image = image
                self.loading = false
            }
        }
    }
}

struct LoadableImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadableImageView(imagePath: OrgChart.mock.renderContext.topLeft!.members.first!.picture)
    }
}
