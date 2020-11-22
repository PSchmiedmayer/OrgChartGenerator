//
//  HeaderView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 6/17/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChartRenderContext


struct HeaderView: View {
    @ObservedObject var teamHeader: TeamHeader
    
    
    var body: some View {
        switch teamHeader.content {
        case let .image(image):
            let binding = Binding(get: {
                image as NSImage?
            }, set: { _ in })
            return AnyView(
                PrintableImage(image: binding, mode: .scaleToFit)
                    .padding(4)
            )
        case let .text(text):
            return AnyView(
                Text(text)
                    .font(.system(size: 50, weight: .medium))
                    .padding(4)
            )
        }
    }
}
