//
//  OrgChartView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart

struct OrgChartView: View {
    @Binding var context: OrgChartRenderContext
    
    var body: some View {
        VStack(spacing: 64) {
            OrgChartHeader(context: $context)
            OrgChartBody(context: $context)
        }.padding(32)
            .printableBackground(.white)
    }
}

struct OrgChartView_Previews: PreviewProvider {
    @State static var renderContext = OrgChartRenderContext.mock
    
    static var previews: some View {
        OrgChartView(context: $renderContext)
            .background(Color(.white))
    }
}
