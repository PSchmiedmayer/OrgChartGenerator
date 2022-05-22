//
//  ColorScheme.swift
//  OrgChart Generator
//
//  Created by Martin Fink on 19.05.22.
//  Copyright © 2022 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func preferredColorSchemeCompat(_ colorScheme: ColorScheme) -> some View {
        if #available(macOS 11.0, *) {
            return AnyView(self.preferredColorScheme(colorScheme))
        } else {
            return AnyView(self.colorScheme(colorScheme))
        }
    }
}
