//
//  BackgroundView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/23/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChartRenderContext


extension Background {
    var view: AnyView {
        guard let border = border else {
            return AnyView(PrintableRectangle(color: color))
        }
        
        return AnyView(
            PrintableRectangle(color: color)
                .printableBorder(border.color, width: border.width)
        )
    }
}
