//
//  Header.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart

struct OrgChartHeader: View {
    var context: OrgChartRenderContext
    
    var body: some View {
        HStack(spacing: 120) {
            context.topLeft.map { topLeft in
                BoxView(box: topLeft)
            }
            Text(context.title)
                .font(.system(size: 120, weight: .medium))
            context.topRight.map { topRight in
                BoxView(box: topRight)
            }
        }.fixedSize(horizontal: true, vertical: true)
    }
}

struct OrgChartHeader_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartHeader(context: OrgChart.mock.renderContext)
    }
}
