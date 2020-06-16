//
//  OrgChartRenderContext.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import OrgChart
import AppKit
import Combine


class OrgChartRenderContext: ImageLoadable, ObservableObject {
    let title: String
    @Published var topLeft: Box?
    @Published var topRight: Box?
    @Published var teams: [Team]
    @Published var rows: [Row]
    
    
    init(_ orgChart: OrgChart) {
        self.title = orgChart.title
        
        // Top Left
        self.topLeft = orgChart.crossTeamRoles
            .first(where: { $0.position == .topLeft })
            .map { crossTeamRole in
                Box(crossTeamRole)
            }
        
        // Top Right
        self.topRight = orgChart.crossTeamRoles
            .first(where: { $0.position == .topRight })
            .map { crossTeamRole in
                Box(crossTeamRole)
            }
        
        // Teams
        self.teams = orgChart.teams
            .map { orgChartTeam in
                Team(orgChartTeam)
            }
        
        // Rows
        let positions = Set(orgChart.teams.flatMap({ $0.members.keys })).sorted()
        self.rows = positions
            .map { position in
                Row(orgChart, position: position)
            }
    }
    
    
    func loadImages() {
        topLeft?.loadImages()
        topRight?.loadImages()
        
        for index in teams.indices {
            teams[index].loadImages()
        }
        
        for index in rows.indices {
            rows[index].loadImages()
        }
    }
    
    func cropImages(cropFaces: Bool, size: CGSize) -> AnyPublisher<Void, Never> {
        var publishers : [AnyPublisher<Void, Never>] = [
            topLeft?.cropImages(cropFaces: cropFaces, size: size) ?? Just(Void()).eraseToAnyPublisher(),
            topRight?.cropImages(cropFaces: cropFaces, size: size) ?? Just(Void()).eraseToAnyPublisher(),
        ]
        
        publishers.append(contentsOf:
            rows.indices
                .map { index in
                    rows[index].cropImages(cropFaces: cropFaces, size: size)
                }
        )
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { _ in }
            .eraseToAnyPublisher()
    }
}


extension OrgChartRenderContext: Equatable {
    static func == (lhs: OrgChartRenderContext, rhs: OrgChartRenderContext) -> Bool {
        lhs.title == rhs.title
            && lhs.topLeft == rhs.topLeft
            && lhs.topRight == rhs.topRight
            && lhs.teams == rhs.teams
            && lhs.rows == rhs.rows
    }
}


extension OrgChartRenderContext: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(topLeft)
        hasher.combine(topRight)
        hasher.combine(teams)
        hasher.combine(rows)
    }
}
