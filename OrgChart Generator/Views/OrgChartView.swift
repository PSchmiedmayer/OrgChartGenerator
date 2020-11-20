//
//  OrgChartView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChartRenderContext


struct OrgChartView: View {
    @ObservedObject var context: OrgChartRenderContext
    
    var body: some View {
        VStack(spacing: 64) {
            OrgChartHeader(context: context)
            OrgChartBody(context: context)
        }.padding(32)
            .printableBackground(.white)
    }
}

struct OrgChartView_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartView(context: OrgChartRenderContext.mock)
            .background(Color(NSColor.white))
    }
}
