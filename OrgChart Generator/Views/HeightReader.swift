//
//  HeightReader.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


protocol HeightPreferenceKey: PreferenceKey {}


extension HeightPreferenceKey {
    static var defaultValue: CGFloat {
        .zero
    }

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct HeightReader<K : PreferenceKey>: ViewModifier where K.Value == CGFloat {
    var preferenceKey: K.Type
    
    
    private var heightReaderView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: self.preferenceKey.self,
                                   value: geometry.size.height)
        }
    }
    

    func body(content: Content) -> some View {
        content.background(heightReaderView)
    }
}
