//
//  OrgChartTeam.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart


struct Team {
    let id: UUID = UUID()
    let header: TeamHeader
    let background: Background
    
    
    init(_ team: OrgChartTeam) {
        self.header = TeamHeader(team)
        self.background = Background(color: team.background.color.withAlphaComponent(Constants.Team.backgroundAlpha))
    }
}


extension Team: Hashable { }


extension Team: Identifiable { }
