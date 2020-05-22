//
//  TeamHeaderView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct TeamHeaderView: View {
    var teamStyles: [OrgChartRenderContext.Style]
    @Binding var managementWidth: CGFloat
    
    var body: some View {
        TeamView(managementWidth: $managementWidth, data: teamStyles) { teamStyle in
            ZStack {
                Color.white
                Color(teamStyle.background.color.withAlphaComponent(0.1))
                LoadableImageView(imagePath: teamStyle.logo, displayMode: .scaleToFit)
            }.frame(height: 120)
                .padding(6)
        }
    }
}

struct TeamHeaderView_Previews: PreviewProvider {
    @State static var managementWidth: CGFloat = 64
    
    static var previews: some View {
        TeamHeaderView(teamStyles: OrgChart.mock.renderContext.teamStyles,
                       managementWidth: $managementWidth)
            .previewLayout(.fixed(width: 6000, height: 100))
            .background(Color.white)
    }
}
