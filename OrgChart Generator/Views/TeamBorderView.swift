//
//  TeamBorderView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct TeamBorderView: View {
    var teamStyles: [OrgChartRenderContext.Style]
    @Binding var managementWidth: CGFloat
    
    
    var body: some View {
        TeamView(managementWidth: $managementWidth, data: teamStyles) { teamStyle in
            Color.clear
                .border(Color(teamStyle.background.color.withAlphaComponent(1.0)), width: 3)
        }
    }
}

struct TeamBorderView_Previews: PreviewProvider {
    @State static var managementWidth: CGFloat = 64
    
    static var previews: some View {
        TeamBorderView(teamStyles: OrgChart.mock.renderContext.teamStyles,
                       managementWidth: $managementWidth)
    }
}
