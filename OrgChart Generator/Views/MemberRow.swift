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
        HStack(alignment: .top, spacing: 32) {
            ForEach(row.teamMembers, id: \.hashValue) { teamMembers in
                VStack(spacing: 0) {
                    self.row.heading.map { heading in
                        Text(heading)
                            .font(.system(size: 27, weight: .semibold))
                            .padding(8)
                            .padding(.vertical, 16)
                            .padding(.bottom, 24)
                            .modifier(HeightReader(preferenceKey: HeadingHeightPreferenceKey.self))
                    }
                    VStack(spacing: 16) {
                        ForEach(teamMembers, id: \.hashValue) { member in
                            MemberView(member: member, accentColor: .black)
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }.fixedSize(horizontal: true, vertical: true)
    }
}


struct MemberRow_Previews: PreviewProvider {
    static var previews: some View {
        MemberRow(row: OrgChart.mock.renderContext.rows[3])
            .background(Color(.white))
    }
}
