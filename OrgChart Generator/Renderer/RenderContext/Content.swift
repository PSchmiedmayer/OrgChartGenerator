//
//  Content.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit

enum Content {
    case image(NSImage)
    case text(String)
}

extension Content: Hashable {}
