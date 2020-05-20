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
    @State var orgChart: OrgChart
    @State var estimatedSize: CGSize = CGSize(width: 1920, height: 1080)
    
    var body: some View {
        Text("OrgChart")
    }
}

struct OrgChartView_Previews: PreviewProvider {
    static var orgChart: OrgChart = OrgChart.mock
    
    static var previews: some View {
        OrgChartView(orgChart: orgChart)
    }
}
