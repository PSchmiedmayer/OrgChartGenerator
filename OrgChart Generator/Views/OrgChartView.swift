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
    var context: OrgChartRenderContext
    @State var estimatedSize: CGSize = CGSize(width: 1920, height: 1080)
    
    var body: some View {
        VStack {
            OrgChartHeader(context: context)
            OrgChartBody(context: context)
        }
    }
}

struct OrgChartView_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartView(context: OrgChart.mock.renderContext)
            .background(Color(.white))
    }
}