//
//  TeamBackgroundView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct TeamBackgroundView: View {
    var teamStyles: [OrgChartRenderContext.Style]
    @Binding var managementWidth: CGFloat
    
    var body: some View {
        TeamView(managementWidth: $managementWidth, data: teamStyles) { teamStyle in
            Color(teamStyle.background.color.withAlphaComponent(0.15))
        }
    }
}

struct TeamBackgroundView_Previews: PreviewProvider {
    @State static var managementWidth: CGFloat = 64
    
    static var previews: some View {
        TeamBackgroundView(teamStyles: OrgChart.mock.renderContext.teamStyles,
                           managementWidth: $managementWidth)
    }
}
