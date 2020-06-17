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
        case let .image(imageState):
            let binding = Binding(get: {
                return imageState
            }, set: { _ in })
            return AnyView(
                PrintableImage(imageState: binding, mode: .scaleToFit)
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
