//
//  Background.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit


struct Background {
    let color: NSColor
    let border: Border? = nil
    
    init(color: NSColor, border: Border? = nil) {
        self.color = color
        self.border = border
    }
}

extension Background: Hashable { }
