//
//  Header.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart

struct OrgChartHeader: View {
    @Binding var context: OrgChartRenderContext
    
    var unsafeTopLeftBinding: Binding<Box> {
        Binding(get: {
            self.context.topLeft!
        }) { newTopLeft in
            self.context.topLeft = newTopLeft
        }
    }
    
    var unsafeTopRightBinding: Binding<Box> {
        Binding(get: {
            self.context.topRight!
        }) { newTopRight in
            self.context.topRight = newTopRight
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if context.topLeft != nil {
                BoxView(box: unsafeTopLeftBinding)
            }
            Spacer(minLength: 120)
            Text(context.title)
                .font(.system(size: 120, weight: .medium))
                .fixedSize(horizontal: true, vertical: true)
            Spacer(minLength: 120)
            if context.topRight != nil {
                BoxView(box: unsafeTopRightBinding)
            }
        }
    }
}

struct OrgChartHeader_Previews: PreviewProvider {
    @State static var renderContext = OrgChartRenderContext.mock
    
    static var previews: some View {
        OrgChartHeader(context: $renderContext)
            .background(Color.white)
    }
}
