//
//  OrgChartImageView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChartRenderContext
import ImageProcessor
import Combine


struct OrgChartImageView: View {
    @EnvironmentObject var generator: OrgChartGenerator
    
    @State var displayMode: ImageDisplayMode = .scaleToFill
    @Binding var imageState: ImageState
    
    
    var displayLoading: Bool {
        switch imageState {
        case .cropped, .cloudNotBeLoaded:
            return false
        default:
            return generator.loading
        }
    }
    
    var body: some View {
        ZStack {
            if imageState.image == nil {
                Rectangle()
                    .foregroundColor(Color(.lightGray))
            }
            PrintableImage(imageState: $imageState, mode: displayMode)
            ActivityIndicator(loading: displayLoading)
        }
    }
}

struct OrgChartImageView_Previews: PreviewProvider {
    @State static var imageState = OrgChartRenderContext.mock.topLeft!.members.first!.imageState
    @State static var loading = true
    
    static var previews: some View {
        OrgChartImageView(imageState: $imageState)
    }
}
