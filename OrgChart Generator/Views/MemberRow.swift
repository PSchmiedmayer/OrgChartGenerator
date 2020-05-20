//
//  MemberRow.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct MemberRow: View {
    let row: OrgChartRenderContext.Row
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(row.teamMembers, id: \.hashValue) { teamMembers in
                VStack {
                    self.row.heading.map { heading in
                        VStack {
                            Spacer()
                                .frame(height: 36)
                            Text(heading)
                                .font(.system(size: 27, weight: .semibold))
                        }.padding(8)
                    }
                    if teamMembers.count == 0 {
                        Text("No Team Member")
                    }
                    ForEach(teamMembers, id: \.hashValue) { member in
                        MemberView(member: member, accentColor: .black)
                            .padding(.horizontal, 16)
                    }
                }
            }
        }.fixedSize(horizontal: true, vertical: true)
    }
}


struct MemberRow_Previews: PreviewProvider {
    static var previews: some View {
        MemberRow(row: OrgChart.mock.renderContext.rows.first!)
    }
}
