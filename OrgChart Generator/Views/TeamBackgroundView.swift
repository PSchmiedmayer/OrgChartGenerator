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
    var teams: [Team]
    
    @Binding var managementWidth: CGFloat
    
    
    var body: some View {
        TeamView(managementWidth: $managementWidth, data: teams) { team in
            PrintableRectangle(color: team.background.color)
        }
    }
}

struct TeamBackgroundView_Previews: PreviewProvider {
    @State static var managementWidth: CGFloat = 64
    
    static var previews: some View {
        TeamBackgroundView(teams: OrgChartRenderContext.mock.teams,
                           managementWidth: $managementWidth)
    }
}
