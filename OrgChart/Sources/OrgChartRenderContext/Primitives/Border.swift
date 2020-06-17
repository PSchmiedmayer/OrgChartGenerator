//
//  Border.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit


public struct Border {
    public let color: NSColor
    public let width: CGFloat
}


extension Border: Hashable {}
