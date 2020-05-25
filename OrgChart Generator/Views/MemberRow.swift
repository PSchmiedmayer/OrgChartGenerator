//
//  MemberRow.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct MemberRow: View {
    @Binding var row: Row
    
    var body: some View {
        HStack(alignment: .top, spacing: 32) {
            ForEach(row.teams.indices) { teamMembersIndex in
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
                        ForEach(self.row.teams[teamMembersIndex].indices) { memberIndex in
                            MemberView(member: self.$row.teams[teamMembersIndex][memberIndex],
                                       accentColor: self.row.background?.border?.color ?? .clear)
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }.fixedSize(horizontal: true, vertical: true)
    }
}


struct MemberRow_Previews: PreviewProvider {
    @State static var row: Row = OrgChartRenderContext.mock.rows[3]
    
    static var previews: some View {
        MemberRow(row: $row)
            .background(Color.white)
    }
}
