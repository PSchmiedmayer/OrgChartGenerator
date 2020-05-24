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
    
    @State var displayMode: ImageDisplayMode = .scaleToFill
    @Binding var imageState: ImageState
    
    
    var loading: Bool {
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
            ActivityIndicator(loading: generator.loading)
            PrintableImage(imageState: $imageState, mode: displayMode)
        }
    }
}

struct OrgChartImageView_Previews: PreviewProvider {
    @State static var imageState = OrgChartRenderContext.mock.topLeft!.members.first!.imageState
    
    static var previews: some View {
        OrgChartImageView(imageState: $imageState)
    }
}
