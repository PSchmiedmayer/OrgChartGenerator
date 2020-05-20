//
//  ControlView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI

struct ControlView: View {
    @ObservedObject var generator: OrgChartGenerator
    
    var body: some View {
        Text("ControlView")
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(generator: OrgChartGenerator())
    }
}
