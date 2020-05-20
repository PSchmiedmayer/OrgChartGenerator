//
//  BoxView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct BoxView: View {
    var box: OrgChartRenderContext.Box
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            box.title.map { title in
                Text(title)
                    .font(.system(size: 27, weight: .semibold))
            }
            HStack(alignment: .center, spacing: 8) {
                ForEach(box.members, id: \.hashValue) { member in
                    MemberView(member: member, accentColor: self.box.background.color)
                }
            }
        }
            .padding(.all, 16)
            .background(
                Color(box.background.color.withAlphaComponent(0.15))
                    .border(Color(box.background.color.withAlphaComponent(1.0)), width: 3)
            )
            .padding()
            .fixedSize(horizontal: true, vertical: true)
    }
}

struct BoxView_Previews: PreviewProvider {
    static var previews: some View {
        BoxView(box: OrgChart.mock.renderContext.topLeft!)
            .previewLayout(.sizeThatFits)
    }
}
