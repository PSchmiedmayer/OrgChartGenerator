//
//  CrossTeamRole.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation

/// Represents a cross team role in the OrgChart
public final class CrossTeamRole {
    /// The title of the cross team role
    public let title: String
    /// The heading that should used to represent the cross team role
    public let heading: String?
    /// The position of the cross team role
    public let position: Position
    /// The background that should be used to render the cross team role
    public let background: Background
    /// The management of the cross team role
    public var management: [OrgChartMember]
    
    init(fromDirectory directory: URL) throws {
        let information = try directory.extractInformation()
        guard let position = information.position else {
            throw OrgChartError.impossibleToExtractInformation(directory.lastPathComponent)
        }
        
        self.title = information.name
        self.heading = information.role
        self.position = position
        self.background = information.color ?? .white
        self.management = []
        
        try directory.content()
            .forEach { fileURL in
                guard !fileURL.hasDirectoryPath else {
                    return
                }
                let memberInformation = try fileURL.extractInformation()
                
                management.append(OrgChartMember(name: memberInformation.name,
                                                 picture: fileURL,
                                                 role: memberInformation.role))
            }
    }
}

extension CrossTeamRole: Equatable {
    public static func == (lhs: CrossTeamRole, rhs: CrossTeamRole) -> Bool {
        lhs.position == rhs.position
    }
}

extension CrossTeamRole: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

extension CrossTeamRole: Identifiable {
    public var id: String {
        title
    }
}

extension CrossTeamRole: CustomStringConvertible {
    public var description: String {
        #"""
        Cross Project Role: "\#(title)"
        Position: "\#(position)" - Background: \#(background.description)
        Management: \#(management)
        """#
    }
}
