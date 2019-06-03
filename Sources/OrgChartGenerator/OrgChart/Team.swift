//
//  Team.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//

import Foundation

struct Team {
    let name: String
    let logo: URL
    let background: Background
    let members: [Position: [Member]]
    
    init(name: String, logo: URL, background: Background, members: [Position: [Member]]) throws {
        for position in members.keys {
            guard case .row(_) = position else {
                throw OrgChartError.impossibleTeamPosition(position)
            }
        }
        
        self.name = name
        self.logo = logo
        self.background = background
        self.members = members
    }
    
    init(fromDirectory directory: URL) throws {
        // Name
        let teamName = directory.extractInformation().name
        
        // Logo
        var content = try directory.content()
        guard let logoURL = content.first(where: { $0.extractInformation().name == teamName }) else {
            throw OrgChartError.noLogo(named: teamName, at: directory)
        }
        content.removeAll(where: { $0 == logoURL })
        
        // Members
        var members: [Position: [Member]] = [:]
        for teamMembersURL in content {
            let information = teamMembersURL.extractInformation()
            guard let position = information.position else {
                throw OrgChartError.impossibleToExtractInformation(teamMembersURL.lastPathComponent)
            }
            
            if teamMembersURL.hasDirectoryPath {
                try members.appendMembers(inDirectory: teamMembersURL, atPosition: position, withDefaultRole: information.role)
            } else {
                try members.append(member: Member(name: information.name, picture: teamMembersURL, role: information.role), at: position)
            }
        }
        
        try self.init(name: teamName,
                      logo: logoURL,
                      background: logoURL.extractInformation().color ?? .white,
                      members: members)
    }
}

extension Team: CustomStringConvertible {
    var description: String {
        let membersDescription = members.keys.map({ "\t\t \($0.description): \(members[$0]?.description ?? "[]")"}).joined(separator: "\n")
        return #"""
        Name: "\#(name)"
        Logo: "\#(logo.lastPathComponent)" - Background: \#(background.description)
        Members:
        \#(membersDescription)
        """#
    }
}
