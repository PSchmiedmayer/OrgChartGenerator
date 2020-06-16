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
    @ObservedObject var box: Box
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            box.title.map { title in
                Text(title)
                    .font(.system(size: 27, weight: .semibold))
            }
            HStack(alignment: .center, spacing: 8) {
                ForEach(box.members.indices) { memberIndex in
                    MemberView(member: self.box.members[memberIndex],
                               accentColor: self.box.background?.color ?? .clear)
                }
            }
        }
            .padding(.all, 16)
            .background(box.background?.view ?? AnyView(EmptyView()))
            .fixedSize(horizontal: true, vertical: true)
    }
}

struct BoxView_Previews: PreviewProvider {
    static var previews: some View {
        BoxView(box: OrgChartRenderContext.mock.topLeft!)
            .previewLayout(.sizeThatFits)
    }
}
