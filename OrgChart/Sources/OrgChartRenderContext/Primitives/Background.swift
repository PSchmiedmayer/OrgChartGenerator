//
//  Background.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit


public struct Background {
    public let color: NSColor
    public let border: Border?
    
    init(color: NSColor, border: Border? = nil) {
        self.color = color
        self.border = border
    }
}

extension Background: Hashable { }
