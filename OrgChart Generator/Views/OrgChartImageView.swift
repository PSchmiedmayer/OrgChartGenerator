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
import Combine


struct OrgChartImageView: View {
    @EnvironmentObject var generator: OrgChartGenerator
    
    var displayMode: ImageDisplayMode = .scaleToFill
    var imageState: ImageState
    
    
    var body: some View {
        ZStack {
            if imageState.image == nil {
                Rectangle()
                    .foregroundColor(Color(.lightGray))
            }
            ActivityIndicator(loading: generator.loading)
            imageState.image.map { image in
                PrintableImage(image: image, mode: displayMode)
            }
        }
    }
}

struct LoadableImageView_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartImageView(imageState: OrgChartRenderContext.mock.topLeft!.members.first!.imageState)
    }
}
