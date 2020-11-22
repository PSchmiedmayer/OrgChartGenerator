//
//  Background.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit


/// A structure to represent a background of the OrgChart
public struct Background {
    /// The color of the background
    public let color: NSColor
    /// The border of the background
    public let border: Border?
    
    init(color: NSColor, border: Border? = nil) {
        self.color = color
        self.border = border
    }
}

extension Background: Hashable { }
