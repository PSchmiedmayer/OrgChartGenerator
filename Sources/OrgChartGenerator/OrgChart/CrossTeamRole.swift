//
//  CrossTeamRole.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//

import Foundation

struct CrossTeamRole: Equatable, Hashable {
    let title: String
    let heading: String?
    let position: Position
    let background: Background
    private(set) var management: [Member]
    
    init(fromDirectory directory: URL) throws {
        let information = directory.extractInformation()
        guard let position = information.position else {
            throw OrgChartError.impossibleToExtractInformation(directory.lastPathComponent)
        }
        
        self.title = information.name
        self.heading = information.role
        self.position = position
        self.background = (try? information.role.flatMap(Background.init(hexString:))) ?? .clear
        self.management = []
        
        try directory.content().forEach({ fileURL in
            guard !fileURL.hasDirectoryPath else {
                return
            }
            let memberInformation = fileURL.extractInformation()
            
            management.append(Member(name: memberInformation.name, picture: fileURL, role: memberInformation.role))
        })
    }
    
    static func == (lhs: CrossTeamRole, rhs: CrossTeamRole) -> Bool {
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

extension CrossTeamRole: CustomStringConvertible {
    var description: String {
        return #"""
        Cross Project Role: "\#(title)"
        Position: "\#(position)" - Background: \#(background.description)
        Management: \#(management)
        """#
    }
}
