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
                self.image(teamStyle.logo)
            }.frame(height: 120)
                .padding(6)
        }
    }
    
    func image(_ logo: URL) -> some View {
        guard let image = NSImage(contentsOfFile: logo.path) else {
            return AnyView(
                EmptyView()
            )
        }
        
        return AnyView(
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
        )
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
