//
//  TeamView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct ManagementWidthPreferenceKey: WidthPreferenceKey {}


struct OrgChartBody: View {
    var context: OrgChartRenderContext
    @State var managementWidth: CGFloat = .zero
    
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                HStack(spacing: 32) {
                    ForEach(context.teamStyles, id: \.hashValue) { teamStyle in
                        Color(teamStyle.background.color.withAlphaComponent(0.15))
                    }
                }
                Spacer()
                    .frame(width: managementWidth)
            }
            VStack(alignment: .leading) {
                ForEach(context.rows, id: \.hashValue) { row in
                    OrgChartRow(row: row)
                }
            }
                .onPreferenceChange(ManagementWidthPreferenceKey.self) { managementWidth in
                    self.managementWidth = managementWidth
                }
        }.fixedSize(horizontal: true, vertical: true)
    }
}


struct OrgChartBody_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartBody(context: OrgChart.mock.renderContext)
            .background(Color(.white))
    }
}
