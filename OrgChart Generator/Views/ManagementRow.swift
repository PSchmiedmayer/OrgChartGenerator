//
//  ManagementRow.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct ManagementRow: View {
    @Binding var headingHeight: CGFloat
    let row: OrgChartRenderContext.Row
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            row.management.map { management in
                ForEach(management.members, id: \.hashValue) { member in
                    VStack(spacing: 0) {
                        self.row.heading.map { heading in
                            Color.clear
                                .frame(height: self.headingHeight)
                        }
                        MemberView(member: member, accentColor: .black)
                            .padding(.horizontal, 16)
                    }
                }
            }
            Spacer()
            row.management?.title.map { title in
                VStack(spacing: 0) {
                    self.row.heading.map { heading in
                        Color.clear
                            .frame(height: self.headingHeight)
                    }
                    Spacer()
                    Text(title)
                        .font(.system(size: 27, weight: .semibold))
                        .padding(.horizontal, 32)
                    Spacer()
                }.fixedSize(horizontal: true, vertical: false)
            }
        }.fixedSize(horizontal: true, vertical: true)
    }
}

struct ManagementRow_Previews: PreviewProvider {
    @State static var headingHeight: CGFloat = 64
    
    static var previews: some View {
        ManagementRow(headingHeight: $headingHeight, row: OrgChart.mock.renderContext.rows[3])
    }
}
