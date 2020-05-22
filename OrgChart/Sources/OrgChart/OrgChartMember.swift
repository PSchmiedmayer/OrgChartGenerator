//
//  Member.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation


public final class OrgChartMember: Codable {
    public let name: String
    public var picture: URL
    public let role: String?
    
    init(name: String, picture: URL, role: String? = nil) {
        self.name = name
        self.picture = picture
        self.role = role
    }
}

extension OrgChartMember: CustomStringConvertible {
    public var description: String {
        guard let role = role else {
            return name
        }
        return "\(name) (\(role))"
    }
}

extension OrgChartMember: Identifiable {
    public var id: URL {
        return picture
    }
}

extension Dictionary where Key == Position, Value == [OrgChartMember] {
    mutating func append(member: OrgChartMember, at position: Position) throws {
        guard case .row(_) = position else {
            throw OrgChartError.impossibleTeamPosition(position)
        }
        
        if self[position] == nil {
            self[position] = []
        }
        self[position]?.append(member)
    }
    
    mutating func appendMembers(inDirectory directory: URL, atPosition position: Position, withDefaultRole role: String? = nil) throws {
        try directory.content().forEach({ fileURL in
            guard !fileURL.hasDirectoryPath else {
                return
            }
            let memberInformation = try fileURL.extractInformation()
            
            try append(member: OrgChartMember(name: memberInformation.name,
                                              picture: fileURL,
                                              role: memberInformation.role ?? role),
                       at: position)
        })
    }
}
