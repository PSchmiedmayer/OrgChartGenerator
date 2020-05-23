//
//  ManagementRow.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct ManagementRow: View {
    @Binding var headingHeight: CGFloat
    let row: Row
    
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
        }.modifier(WidthReader(preferenceKey: ManagementRowWidthPreferenceKey.self))
            .fixedSize(horizontal: true, vertical: true)
    }
}


struct ManagementRow_Previews: PreviewProvider {
    @State static var headingHeight: CGFloat = 64
    
    static var previews: some View {
        ManagementRow(headingHeight: $headingHeight,
                      row: OrgChartRenderContext.mock.rows[3])
            .background(Color.white)
    }
}
