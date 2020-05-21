//
//  WidthReader.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


protocol WidthPreferenceKey: PreferenceKey {}


extension WidthPreferenceKey {
    static var defaultValue: CGFloat {
        .zero
    }

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}


struct WidthReader<K : PreferenceKey>: ViewModifier where K.Value == CGFloat {
    var preferenceKey: K.Type
    
    private var widthReaderView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: K.self,
                                   value: geometry.size.width)
        }
    }

    func body(content: Content) -> some View {
        content.background(widthReaderView)
    }
}
