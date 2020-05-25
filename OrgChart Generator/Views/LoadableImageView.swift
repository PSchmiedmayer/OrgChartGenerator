//
//  OrgChartImageView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart
import ImageProcessor

struct OrgChartImageView: View {
    enum ImageState {
        case faceCropped
        case cropped
    }
    @EnvironmentObject var generator: OrgChartGenerator
    
    var imagePath: URL
    var displayMode: ImageDisplayMode = .scaleToFill
    
    @State private var data: Data?
    @State private var image: NSImage?
    @State private var imageState: ImageState?
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
            guard let data = self.data ?? (try? Data(contentsOf: self.imagePath)),
                  var image = self.image ?? NSImage(data: data) else {
                DispatchQueue.main.async {
                    self.errorMessage = """
                        ⚠️
                        Could not be loaded
                    """
                    self.loading = false
                }
                return
            }
            
            let size = CGSize(width: self.generator.settings.imageSize,
                              height: self.generator.settings.imageSize)
            
            if self.generator.settings.cropFaces &&
               self.imageState != .faceCropped {
                image = ImageProcessor.process(image: image,
                                               withTransformations: [
                    .cropSquareCenteredOnFace
                ])
                
                DispatchQueue.main.async {
                    self.imageState = .faceCropped
                    self.data = data
                    self.image = image
                    self.loading = false
                }
            } else if self.imageState != .cropped {
                image = ImageProcessor.process(image: image, withTransformations: [
                    .scale(toSize: size)
                ])
                DispatchQueue.main.async {
                    self.imageState = .cropped
                    self.data = data
                    self.image = image
                    self.loading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.data = data
                    self.image = image
                    self.loading = false
                }
            }
        }
    }
}

struct LoadableImageView_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartImageView(imagePath: OrgChart.mock.renderContext.topLeft!.members.first!.picture)
    }
}
