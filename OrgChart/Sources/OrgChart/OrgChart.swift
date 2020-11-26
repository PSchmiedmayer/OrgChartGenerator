//
//  OrgChart.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/17/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import AppKit


/// Represents an OrgChart that can be read from a directory structure
public final class OrgChart {
    /// The title of the OrgChart
    public let title: String
    /// The teams that are represented in the OrgChart
    public var teams: [OrgChartTeam]
    /// Cross project teams that can be part of the OrgChart
    public var crossTeamRoles: [CrossTeamRole]
    
    
    /// Initialize an OrgChart from a directory structure
    /// - Parameter orgChartDirectory: The `URL` where the OrgChart should be loaded from
    /// - Throws: Throws an error if the OrgChart could not be parsed from the directory structure
    public init(fromDirectory orgChartDirectory: URL) throws {
        guard orgChartDirectory.hasDirectoryPath else {
            throw OrgChartError.notADirectory(orgChartDirectory)
        }
        
        self.title = try orgChartDirectory.extractInformation().name
        
        let teamsDirectory = orgChartDirectory.appendingPathComponent("Teams", isDirectory: true)
        self.teams = try teamsDirectory.content().map(OrgChartTeam.init)
        
        let crossTeamRolesDirectory = orgChartDirectory.appendingPathComponent("CrossTeamRoles", isDirectory: true)
        self.crossTeamRoles = try crossTeamRolesDirectory.content().map(CrossTeamRole.init)
        
        if teams.isEmpty && crossTeamRoles.isEmpty {
            print("The OrgChart Generator could not load any teams and cross team roles.")
            throw OrgChartError.couldNotReadData(from: orgChartDirectory)
        }
    }
}

extension OrgChart: CustomStringConvertible {
    public var description: String {
        #"""
        Orgchart: "\#(title)"
        Management:
        \#(crossTeamRoles.map { $0.description }.joined(separator: "\n"))
        Teams:
        \#(teams.map { $0.description }.joined(separator: "\n"))
        """#
    }
}
