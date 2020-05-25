//
//  TeamBorderView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct TeamBorderView: View {
    var teams: [Team]
    
    @Binding var managementWidth: CGFloat
    
    
    var body: some View {
        TeamView(managementWidth: $managementWidth, data: teams) { team in
            PrintableBorder(color: team.background.color, width: 3)
        }
    }
}


struct TeamBorderView_Previews: PreviewProvider {
    @State static var managementWidth: CGFloat = 64
    
    static var previews: some View {
        TeamBorderView(teams: OrgChartRenderContext.mock.teams,
                       managementWidth: $managementWidth)
    }
}
