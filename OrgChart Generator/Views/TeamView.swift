//
//  TeamView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct TeamView<Data, Content: View>: View where Data: RandomAccessCollection, Data.Element: Identifiable {
    @Binding var managementWidth: CGFloat
    
    var data: Data
    var content: (Data.Element) -> Content
    
    var body: some View {
        HStack(spacing: 32) {
            HStack(spacing: 32) {
                ForEach(data) { element in
                    self.content(element)
                }
            }
            Color.clear
                .frame(width: managementWidth)
        }
    }
}
