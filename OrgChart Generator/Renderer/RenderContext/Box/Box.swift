//
//  Box.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation

struct Box {
    let id: UUID = UUID()
    let title: String?
    let background: Background?
    let members: [Member]
    
    init(title: String? = nil, background: Background? = nil, members: [Member]) {
        self.title = title
        self.background = background
        self.members = members
    }
}


extension Box: Hashable { }


extension Box: Identifiable { }
