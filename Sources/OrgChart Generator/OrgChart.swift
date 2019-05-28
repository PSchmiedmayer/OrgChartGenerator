//
//  OrgChart.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/17/19.
//

import Foundation
import AppKit

enum OrgChartError: Error {
    case notADirectory(URL)
    case unknownPosition(String)
    case impossibleTeamPosition(Position)
    case impossibleToExtractInformation(String)
    case noLogo(named: String, at: URL)
    
    var localizedDescription: String {
        switch self {
        case let .notADirectory(url):
            return "The Generator expected a directory at (\(url))."
        case let .impossibleTeamPosition(position):
            return "Position (\(position)) is not a valid position within a team. Only row number are allowed."
        case let .unknownPosition(description):
            return "\(description) is an unknown position. Possible Options are: `TopLeft`, `TopRight`, or any number indicating a row"
        case let .impossibleToExtractInformation(pathComponent):
            return "Can't extract the nescessary information from \"\(pathComponent)\""
        case let .noLogo(name, url):
            return "The Generator expected a logo with the name \(name) at (\(url))."
        }
    }
}

struct OrgChart {
    let title: String
    let teams: [Team]
    let management: [Management]
    
    init(fromDirectory orgChartDirectory: URL) throws {
        guard orgChartDirectory.hasDirectoryPath else {
            throw OrgChartError.notADirectory(orgChartDirectory)
        }
        
        self.title = orgChartDirectory.extractInformation().name
        
        let teamsDirectory = orgChartDirectory.appendingPathComponent("Teams", isDirectory: true)
        self.teams = try teamsDirectory.content().map(Team.init)
        
        let managementDirectory = orgChartDirectory.appendingPathComponent("Management", isDirectory: true)
        self.management = try managementDirectory.content().map(Management.init)
    }
}

extension OrgChart: CustomStringConvertible {
    var description: String {
        return #"""
        Orgchart: "\#(title)"
        Management:
        \#(management.map({ $0.description }).joined(separator: "\n"))
        Teams:
        \#(teams.map({ $0.description }).joined(separator: "\n"))
        """#
    }
}

extension URL {
    /**
     Extracts the position, name and role from the `URL`.
     
     The naming syntax of the file or directory is the following:
     
     ```[POSITION_]NAME[_ROLE][.FILE_EXTENSION]```
     - POSITION: [A valid Position's String representation](x-source-tag://Position) will be ignored.
     - NAME: The `name` return value of the function.
     - ROLE: The `role` return value of the function.
     - FILE_EXTENSION: An optional file extension that is going to be ignored.
     
     Examples of valid file or directory names at the end of the `fileURL` `URL` are:
     - `01_Paul Schmiedmayer_CEO.png`
     - `Paul Schmiedmayer.jpg`
     - `Paul Schmiedmayer`
     - `99_Paul Schmiedmayer.png`
     
     - Returns:
        - position: The name of the entity extracted from the URL as described by the logic in the discussion section.
        - name: The name of the entity extracted from the URL as described by the logic in the discussion section.
        - role: The role of the entity extracted from the URL as described by the logic in the discussion section.
     */
    func extractInformation() -> (position: Position?, name: String, role: String?) {
        let lastPathComponent = self.deletingPathExtension().lastPathComponent
        var components = lastPathComponent.split(whereSeparator: { $0 == "_" })
        
        assert(components.count > 0 && components.count <= 3)
        
        // Extract the POSITION
        var position: Position? = nil
        do {
            if components.count > 1, let potentialPosition = components.first {
                position = try Position(potentialPosition)
                components.removeFirst()
            }
        } catch { }
        
        let name: String = components.first.flatMap(String.init) ?? lastPathComponent
        components.removeFirst()
        
        let role = components.first.flatMap(String.init)
        
        return (position, name, role)
    }
    
    func content() throws -> [URL] {
        guard let directoryEnumerator = FileManager.default.enumerator(at: self,
                                                                       includingPropertiesForKeys: [.isDirectoryKey],
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]) else {
            throw OrgChartError.notADirectory(self)
        }
        
        return directoryEnumerator.compactMap({ $0 as? URL }).sorted(by: { $0.absoluteString < $1.absoluteString })
    }
}

enum Background {
    case none
    case color(NSColor)
    
    init <S: StringProtocol>(_ stringRepresentation: S?) {
        guard let stringRepresentation = stringRepresentation, let color = NSColor(hexString: stringRepresentation) else {
            self = .none
            return
        }
        
        self = .color(color)
    }
}

extension Background: CustomStringConvertible {
    var description: String {
        switch self {
        case .none:
            return "NONE"
        case let .color(color):
            return color.description
        }
    }
}

/// - Tag: Position
enum Position: Equatable, Hashable {
    case topLeft
    case topRight
    case row(Int)
    
    init <S: StringProtocol>(_ stringRepresentation: S) throws {
        switch stringRepresentation.lowercased() {
        case "topleft": self = .topLeft
        case "topright": self = .topRight
        default:
            guard let row = Int(stringRepresentation) else {
                throw OrgChartError.unknownPosition(stringRepresentation.description)
            }
            self = .row(row)
        }
    }
}

extension Position: CustomStringConvertible {
    var description: String {
        switch self {
        case .topLeft:
            return "Top Left"
        case .topRight:
            return "Top Right"
        case let .row(row):
            return "Row \(row)"
        }
    }
}

struct Management: Equatable, Hashable {
    let roleName: String
    let position: Position
    let background: Background
    private(set) var members: [Member]
    
    init(fromDirectory directory: URL) throws {
        let information = directory.extractInformation()
        guard let position = information.position else {
            throw OrgChartError.impossibleToExtractInformation(directory.lastPathComponent)
        }
        
        self.position = position
        self.roleName = information.name
        self.background = Background(information.role)
        self.members = []
        
        try directory.content().forEach({ fileURL in
            guard !fileURL.hasDirectoryPath else {
                return
            }
            let memberInformation = fileURL.extractInformation()
            
            members.append(Member(name: memberInformation.name, picture: fileURL, role: memberInformation.role ?? self.roleName))
        })
    }
    
    static func == (lhs: Management, rhs: Management) -> Bool {
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

extension Management: CustomStringConvertible {
    var description: String {
        return #"""
            Role: "\#(roleName)"
                Position: "\#(position)" - Background: \#(background.description)
                Members: \#(members)
        """#
    }
}

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
                      background: Background(logoURL.extractInformation().role),
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

struct Member {
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

extension NSColor {
    convenience init? <S: StringProtocol>(hexString: S) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet(charactersIn: "#").union(.whitespacesAndNewlines))
        guard let color = UInt32(hexString, radix: 16), hexString.count == 6 || hexString.count == 8 else {
            return nil
        }
        
        func colorSegment(shift: Int8) -> CGFloat {
            return CGFloat(Int(color >> shift) & 0xFF) / 255.0
        }
        
        self.init(red: colorSegment(shift: hexString.count == 6 ? 16 : 24),
                  green: colorSegment(shift: hexString.count == 6 ? 8 : 16),
                  blue: colorSegment(shift: hexString.count == 6 ? 0 : 8),
                  alpha: colorSegment(shift: hexString.count == 6 ? -8 : 0))
    }
}
