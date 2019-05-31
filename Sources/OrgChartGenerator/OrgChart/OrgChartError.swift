//
//  OrgChartError.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//

import Foundation

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
