//
//  OrgChart.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/17/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import AppKit

struct OrgChart {
    let title: String
    let teams: [Team]
    let crossTeamRoles: [CrossTeamRole]
    
    init(fromDirectory orgChartDirectory: URL) throws {
        guard orgChartDirectory.hasDirectoryPath else {
            throw GeneratorError.notADirectory(orgChartDirectory)
        }
        
        self.title = try orgChartDirectory.extractInformation().name
        
        let teamsDirectory = orgChartDirectory.appendingPathComponent("Teams", isDirectory: true)
        self.teams = try teamsDirectory.content().map(Team.init)
        
        let crossTeamRolesDirectory = orgChartDirectory.appendingPathComponent("CrossTeamRoles", isDirectory: true)
        self.crossTeamRoles = try crossTeamRolesDirectory.content().map(CrossTeamRole.init)
    }
}

extension OrgChart: CustomStringConvertible {
    var description: String {
        return #"""
        Orgchart: "\#(title)"
        Management:
        \#(crossTeamRoles.map({ $0.description }).joined(separator: "\n"))
        Teams:
        \#(teams.map({ $0.description }).joined(separator: "\n"))
        """#
    }
}
