//
//  Member.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//

import Foundation

struct Member: Codable {
    let name: String
    let picture: URL
    let role: String?
    
    init(name: String, picture: URL, role: String? = nil) {
        self.name = name
        self.picture = picture
        self.role = role
    }
}

extension Member: CustomStringConvertible {
    var description: String {
        guard let role = role else {
            return name
        }
        return "\(name) (\(role))"
    }
}

extension Dictionary where Key == Position, Value == [Member] {
    mutating func append(member: Member, at position: Position) throws {
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
            let memberInformation = fileURL.extractInformation()
            
            try append(member: Member(name: memberInformation.name, picture: fileURL, role: memberInformation.role ?? role),
                       at: position)
        })
    }
}
