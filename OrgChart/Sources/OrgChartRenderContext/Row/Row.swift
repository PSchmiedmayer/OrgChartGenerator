//
//  Row.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart
import Combine


public class Row: ObservableObject {
    public typealias Team = [Member]
    
    
    public let id: Int
    public let heading: String?
    public let background: Background?
    @Published public private(set) var teams: [Team]
    @Published public private(set) var management: Management?
    
    
    init(id: Int, heading: String? = nil, background: Background? = nil, teams: [Team], management: Management? = nil) {
        self.id = id
        self.heading = heading
        self.background = background
        self.teams = teams
        self.management =  management
    }
    
    convenience init(_ orgChart: OrgChart, position: Position) {
        guard case let .row(id) = position else {
            preconditionFailure("Cross Team for a row must have a row index")
        }
        
        let crossTeamRole = orgChart.crossTeamRoles
            .first(where: { $0.position == position })
        let management = crossTeamRole
            .flatMap { crossTeamRole in
                Management(title: crossTeamRole.title,
                           members: crossTeamRole.management.map { Member($0) })
            }
        
        let background: Background? = crossTeamRole
            .flatMap { crossTeamRole in
                let background: Background?
                if crossTeamRole.background.color == .white {
                    background = nil
                } else {
                    let color = crossTeamRole.background.color
                    background = Background(color: color.withAlphaComponent(Constants.Row.backgroundAlpha),
                                            border: Border(color: color.withAlphaComponent(Constants.Row.borderAlpha),
                                                           width: Constants.Row.borderWidth))
                }
                return background
            }
        let teams: [Team] = orgChart.teams
            .map { team -> [Member] in
                guard let members = team.members[position] else {
                    // Add a placeholder
                    return [Member(name: "...", imageState: .cloudNotBeLoaded)]
                }
                return members
                    .map { orgChartMember in
                        Member(orgChartMember)
                    }
            }
        
        
        self.init(id: id,
                  heading: crossTeamRole?.heading,
                  background: background,
                  teams: teams,
                  management: management)
    }
}


extension Row: ImageHandler {
    func loadImages() {
        for teamIndex in teams.indices {
            for index in teams[teamIndex].indices {
                teams[teamIndex][index].loadImages()
            }
        }
        management?.loadImages()
    }
    
    func cropImages(cropFaces: Bool, size: CGSize) -> AnyPublisher<Void, Never> {
        var publishers: [AnyPublisher<Void, Never>] = []
        for teamIndex in teams.indices {
            for index in teams[teamIndex].indices {
                publishers.append(
                    teams[teamIndex][index].cropImages(cropFaces: cropFaces, size: size)
                )
            }
        }
        publishers.append(management?.cropImages(cropFaces: cropFaces, size: size) ?? Just(Void()).eraseToAnyPublisher())
        return Publishers.MergeMany(publishers)
            .collect()
            .map { _ in }
            .eraseToAnyPublisher()
    }
}


extension Row: Equatable {
    public static func == (lhs: Row, rhs: Row) -> Bool {
        lhs.id == rhs.id
            && lhs.heading == rhs.heading
            && lhs.background == rhs.background
            && lhs.teams == rhs.teams
            && lhs.management == rhs.management
    }
}


extension Row: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(heading)
        hasher.combine(background)
        hasher.combine(teams)
        hasher.combine(management)
    }
}
