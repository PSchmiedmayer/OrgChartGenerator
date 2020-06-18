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
    @Binding var image: NSImage?
    @Binding var loading: Bool
    
    var body: some View {
        ZStack {
            if image == nil {
                Rectangle()
                    .foregroundColor(Color(.lightGray))
            }
            PrintableImage(image: $image, mode: displayMode)
            ActivityIndicator(loading: loading)
        }
    }
}

struct OrgChartImageView_Previews: PreviewProvider {
    @State static var image = OrgChartRenderContext.mock.topLeft!.members.first!.picture
    @State static var loading = true
    
    static var previews: some View {
        OrgChartImageView(image: $image, loading: $loading)
    }
}
