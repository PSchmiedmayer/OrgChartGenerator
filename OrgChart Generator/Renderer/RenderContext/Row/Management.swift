//
//  Management.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation


struct Management {
    let title: String?
    let members: [Member]
    
    init(title: String? = nil, members: [Member]) {
        self.title = title
        self.members = members
    }
}


extension Management: Hashable { }
