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
    private(set) var members: [Member]
    
    
    init(title: String? = nil, members: [Member]) {
        self.title = title
        self.members = members
    }
    
    
    mutating func loadImages() {
        for index in members.indices {
            members[index].loadImage()
        }
    }
}


extension Management: Hashable { }
