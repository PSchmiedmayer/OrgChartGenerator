//
//  Box.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart

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
    
    init(_ crossTeamRole: CrossTeamRole) {
        let color = crossTeamRole.background.color
        let background = Background(color: color.withAlphaComponent(Constants.Box.backgroundAlpha),
                                    border: Border(color: color.withAlphaComponent(Constants.Box.borderAlpha),
                                                   width: Constants.Box.borderWidth))
        let members = crossTeamRole.management.map { Member($0) }
        
        self.init(title: crossTeamRole.title,
                  background: background,
                  members: members)
    }
}


extension Box: Hashable { }


extension Box: Identifiable { }
