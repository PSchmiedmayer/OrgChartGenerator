//
//  OrgChartRenderContext.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import OrgChart
import AppKit


struct OrgChartRenderContext {
    let title: String
    let topLeft: Box?
    let topRight: Box?
    let teams: [Team]
    let rows: [Row]
    
    
    fileprivate init(_ orgChart: OrgChart) {
        self.title = orgChart.title
        
        // Top Left
        self.topLeft = orgChart.crossTeamRoles
            .first(where: { $0.position == .topLeft })
            .map { crossTeamRole in
                Box(crossTeamRole)
            }
        
        // Top Right
        self.topRight = orgChart.crossTeamRoles
            .first(where: { $0.position == .topRight })
            .map { crossTeamRole in
                Box(crossTeamRole)
            }
        
        // Teams
        self.teams = orgChart.teams
            .map { orgChartTeam in
                Team(orgChartTeam)
            }
        
        // Rows
        let positions = Set(orgChart.teams.flatMap({ $0.members.keys })).sorted()
        self.rows = positions
            .map { position in
                Row(orgChart, position: position)
            }
    }
}
