//
//  TeamView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct OrgChartBody: View {
    var context: OrgChartRenderContext
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(context.rows, id: \.hashValue) { row in
                OrgChartRow(row: row)
            }
        }.fixedSize(horizontal: true, vertical: true)
    }
}


struct OrgChartBody_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartBody(context: OrgChart.mock.renderContext)
    }
}
