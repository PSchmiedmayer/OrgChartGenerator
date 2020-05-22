//
//  Member.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit


struct Member {
    let id: UUID = UUID()
    let name: String
    let picture: NSImage?
    let role: String?
    
    
    init(name: String, picture: NSImage? = nil, role: String? = nil) {
        self.name = name
        self.picture = picture
        self.role = role
    }
}


extension Member: Hashable { }


extension Member: Identifiable { }
