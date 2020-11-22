//
//  Content.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit


/// An enum to represent the content of a header in the OrgChart
public enum HeaderContent {
    /// The content is an image
    case image(NSImage)
    /// The content is a text
    case text(String)
}

extension HeaderContent: Hashable {}
