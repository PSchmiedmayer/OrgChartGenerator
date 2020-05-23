//
//  Row.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart


struct Row {
    typealias Team = [Member]
    
    
    let id: Int
    let heading: String?
    let background: Background?
    private(set) var teams: [Team]
    private(set) var management: Management?
    
    
    init(id: Int, heading: String? = nil, background: Background? = nil, teams: [Team], management: Management? = nil) {
        self.id = id
        self.heading = heading
        self.background = background
        self.teams = teams
        self.management =  management
    }
    
    init(_ orgChart: OrgChart, position: Position) {
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
    mutating func loadImages() {
        for teamIndex in teams.indices {
            for index in teams[teamIndex].indices {
                teams[teamIndex][index].loadImages()
            }
        }
        management?.loadImages()
    }
    
    mutating func cropImages(cropFaces: Bool, size: CGSize) {
        for teamIndex in teams.indices {
            for index in teams[teamIndex].indices {
                teams[teamIndex][index].cropImages(cropFaces: cropFaces, size: size)
            }
        }
        management?.cropImages(cropFaces: cropFaces, size: size)
    }
}


extension Row: Hashable { }


extension Row: Identifiable { }
