//
//  OrgChartRow.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct ManagementRowWidthPreferenceKey: WidthPreferenceKey {}
struct RowHeightPreferenceKey: WidthPreferenceKey {}
struct HeadingHeightPreferenceKey: WidthPreferenceKey {}


struct OrgChartRow: View {
    @Binding var row: Row
    
    @State var height: CGFloat = .zero
    @State var headingHeight: CGFloat = .zero
    @State var managementRowWidth: CGFloat = .zero
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 32) {
                MemberRow(row: $row)
                    .onPreferenceChange(HeadingHeightPreferenceKey.self) { headingHeight in
                        self.headingHeight = headingHeight
                    }
                HStack(alignment: .top, spacing: 0) {
                    ManagementRow(headingHeight: $headingHeight,
                                  row: $row)
                        .onPreferenceChange(ManagementRowWidthPreferenceKey.self) { managementRowWidth in
                            self.managementRowWidth = managementRowWidth
                        }
                    Spacer()
                    row.management?.title.map { title in
                        VStack(spacing: 0) {
                            self.row.heading.map { heading in
                                Color.clear
                                    .frame(height: self.headingHeight)
                            }
                            Text(title)
                                .font(.system(size: 27, weight: .semibold))
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.horizontal, 32)
                                .frame(height: headingHeight)
                        }.fixedSize(horizontal: true, vertical: true)
                    }
                }.modifier(WidthReader(preferenceKey: ManagementWidthPreferenceKey.self))
            }.padding(.vertical)
                .modifier(HeightReader(preferenceKey: RowHeightPreferenceKey.self))
                .onPreferenceChange(RowHeightPreferenceKey.self) { height in
                    self.height = height
                }
                .background(background, alignment: .bottom)
        }
    }
    
    var background: AnyView {
        guard let color = row.background?.color else {
            return AnyView(
                EmptyView()
            )
        }
        
        return AnyView(
            PrintableRectangle(color: color.withAlphaComponent(0.1))
                .printableBorder(color.withAlphaComponent(0.5), width: 3)
                .frame(height: height - headingHeight)
        )
    }
}

struct OrgChartRow_Previews: PreviewProvider {
    @State static var row: Row = OrgChartRenderContext.mock.rows[3]
    
    static var previews: some View {
        OrgChartRow(row: $row)
            .background(Color.white)
    }
}
