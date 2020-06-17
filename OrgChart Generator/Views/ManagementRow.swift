//
//  ManagementRow.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChartRenderContext


struct ManagementRow: View {
    @Binding var headingHeight: CGFloat
    @ObservedObject var row: Row
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if row.management != nil {
                ManagementBox(management: row.management!,
                              headingHeight: self.$headingHeight,
                              color: self.row.background?.border?.color ?? .clear)
            } else {
                EmptyView()
            }
        }.modifier(WidthReader(preferenceKey: ManagementRowWidthPreferenceKey.self))
            .fixedSize(horizontal: true, vertical: true)
    }
}

struct ManagementBox: View {
    @ObservedObject var management: Management
    @Binding var headingHeight: CGFloat
    var color: NSColor
    
    var body: some View {
        ForEach(management.members.indices) { memberIndex in
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: self.headingHeight)
                MemberView(member: self.management.members[memberIndex],
                           accentColor: self.color)
                    .padding(.horizontal, 16)
            }
        }
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
