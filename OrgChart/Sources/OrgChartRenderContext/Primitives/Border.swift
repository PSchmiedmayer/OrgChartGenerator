//
//  Border.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit


/// A structure to represent a border of the OrgChart
public struct Border {
    /// The color of the border
    public let color: NSColor
    /// The width of the border
    public let width: CGFloat
}


extension Border: Hashable {}
