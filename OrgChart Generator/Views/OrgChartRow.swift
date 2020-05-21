//
//  OrgChartRow.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct HeightReader: ViewModifier {
    private var heightReaderView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: HeightPreferenceKey.self,
                                   value: geometry.size.height)
        }
    }

    func body(content: Content) -> some View {
        content.background(heightReaderView)
    }
}

struct OrgChartRow: View {
    let row: OrgChartRenderContext.Row
    @State var height: CGFloat = .zero
    @State var headingHeight: CGFloat = .zero
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 0) {
            HStack(alignment: .top) {
                MemberRow(row: row)
                    .onPreferenceChange(HeightPreferenceKey.self) { headingHeight in
                        self.headingHeight = headingHeight
                    }
                ManagementRow(headingHeight: $headingHeight, row: row)
            }.padding(.vertical)
                .modifier(HeightReader())
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    self.height = height
                }
                .background(background, alignment: .bottom)
        }.fixedSize(horizontal: true, vertical: true)
    }
    
    var background: AnyView {
        guard let color = row.background?.color else {
            return AnyView(
                EmptyView()
            )
        }
        
        return AnyView(
            Color(color.withAlphaComponent(0.15))
                .border(Color(color.withAlphaComponent(1.0)), width: 3)
                .frame(height: height - headingHeight)
        )
    }
}

struct OrgChartRow_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartRow(row: OrgChart.mock.renderContext.rows[3])
            .background(Color.white)
    }
}
