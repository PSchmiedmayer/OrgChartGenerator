//
//  Row.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart


struct Row {
    typealias Team = [Member]
    
    let id: Int
    let heading: String?
    let background: Background?
    let teams: [Team]
    let management: Management?
    
    init(id: Int, heading: String? = nil, background: Background? = nil, teams: [Team], management: Management? = nil) {
        self.id = id
        self.heading = heading
        self.background = background
        self.teams = teams
        self.management =  management
    }
    
    init(_ crossTeamRole: CrossTeamRole) {
        init()
    }
}

extension Row: Hashable { }

extension Row: Identifiable { }
