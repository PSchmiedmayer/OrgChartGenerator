//
//  OrgChartTeam.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation


/// Trepresents an OrgChart team that can be parsed from a directory structure
public final class OrgChartTeam {
    /// The team name
    public let name: String
    /// The team logo
    public let logo: URL
    /// The background that should be used to render the team
    public let background: Background
    /// The members of the team
    public var members: [Position: [OrgChartMember]]
    
    init(name: String, logo: URL, background: Background, members: [Position: [OrgChartMember]]) throws {
        for position in members.keys {
            guard case .row = position else {
                throw OrgChartError.impossibleTeamPosition(position)
            }
        }
        
        self.name = name
        self.logo = logo
        self.background = background
        self.members = members
    }
    
    convenience init(fromDirectory directory: URL) throws {
        // Name
        let teamName = try directory.extractInformation().name
        
        // Logo
        var content = try directory.content()
        guard let logoURL = try? content.first(where: { try $0.extractInformation().name == teamName }) else {
            throw OrgChartError.noLogo(named: teamName, url: directory)
        }
        content.removeAll(where: { $0 == logoURL })
        
        // Members
        var members: [Position: [OrgChartMember]] = [:]
        for teamMembersURL in content {
            let information = try teamMembersURL.extractInformation()
            guard let position = information.position else {
                throw OrgChartError.impossibleToExtractInformation(teamMembersURL.lastPathComponent)
            }
            
            if teamMembersURL.hasDirectoryPath {
                try members.appendMembers(inDirectory: teamMembersURL, atPosition: position, withDefaultRole: information.role)
            } else {
                try members.append(member: OrgChartMember(name: information.name,
                                                          picture: teamMembersURL,
                                                          role: information.role),
                                   at: position)
            }
        }
        
        try self.init(name: teamName,
                      logo: logoURL,
                      background: logoURL.extractInformation().color ?? .white,
                      members: members)
    }
}

extension OrgChartTeam: CustomStringConvertible {
    public var description: String {
        let membersDescription = members.keys
            .map { "\t\t \($0.description): \(members[$0]?.description ?? "[]")" }
            .joined(separator: "\n")
        return #"""
        Name: "\#(name)"
        Logo: "\#(logo.lastPathComponent)" - Background: \#(background.description)
        Members:
        \#(membersDescription)
        """#
    }
}

extension OrgChartTeam: Identifiable {
    public var id: String {
        name
    }
}
