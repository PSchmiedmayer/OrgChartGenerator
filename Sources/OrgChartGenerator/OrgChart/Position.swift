//
//  Position.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

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
                throw GeneratorError.unknownPosition(stringRepresentation.description)
            }
            self = .row(row)
        }
    }
}

extension Position: Comparable {
    static func < (lhs: Position, rhs: Position) -> Bool {
        switch (lhs, rhs) {
        case (.topLeft, _):
            return false
        case (_, .topLeft):
            return true
        case let (.row(lhsRow), .row(rhsRow)):
            return lhsRow < rhsRow
        default:
            return false
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
