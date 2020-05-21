//
//  MemberView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct MemberView: View {
    var member: OrgChartRenderContext.Member
    var accentColor: NSColor
    
    var body: some View {
        HStack(alignment: .center, spacing: 8.0) {
            NSImage(contentsOfFile: member.picture.path).map { image in
                PrintableImage(image: image)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .printableBorder(accentColor.withAlphaComponent(0.5), width: 1.5)
            }
            VStack(alignment: .leading, spacing: 4.0) {
                Text(member.name)
                    .font(.system(size: 24, weight: .semibold))
                member.role.map { role in
                    Text(role)
                        .font(.system(size: 22, weight: Font.Weight.light))
                }
            }
            Spacer()
        }
            .aspectRatio(3.8, contentMode: .fit)
            .frame(height: 100)
    }
    
    func imageView() -> some View {
        guard let image = NSImage(contentsOfFile: member.picture.path) else {
            return AnyView(
                PrintableRectangle(color: .systemGray)
            )
        }
        return AnyView(
            Image(nsImage: image)
                .resizable()
                .scaledToFill()
                .aspectRatio(1.0, contentMode: .fit)
        )
    }
}

struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView(member: OrgChart.mock.renderContext.topLeft!.members[0],
                   accentColor: .systemBlue)
            .previewLayout(.sizeThatFits)
    }
}
