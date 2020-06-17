//
//  TeamHeaderView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChartRenderContext


struct TeamHeaderView: View {
    @ObservedObject var context: OrgChartRenderContext
    @Binding var managementWidth: CGFloat
    
    
    var body: some View {
        TeamView(managementWidth: $managementWidth, data: context.teams) { team in
            ZStack {
                Color.white
                self.background(for: team.header)
                HeaderView(teamHeader: team.header)
            }.frame(height: 120)
                .padding(6)
        }
    }
    
    
    func background(for teamHeader: TeamHeader) -> AnyView {
        guard let border = teamHeader.background.border else {
            return AnyView(PrintableRectangle(color: teamHeader.background.color))
        }
        
        return AnyView (
            PrintableRectangle(color: teamHeader.background.color)
                .printableBorder(border.color, width: border.width)
        )
    }
}

struct TeamHeaderView_Previews: PreviewProvider {
    @State static var managementWidth: CGFloat = 64
    
    static var previews: some View {
        TeamHeaderView(context: OrgChartRenderContext.mock,
                       managementWidth: $managementWidth)
            .previewLayout(.fixed(width: 6000, height: 100))
            .background(Color.white)
    }
}
