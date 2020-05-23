//
//  OrgChartRenderContext.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import OrgChart
import AppKit


struct OrgChartRenderContext: ImageLoadable {
    let title: String
    private(set) var topLeft: Box?
    private(set) var topRight: Box?
    private(set) var teams: [Team]
    private(set) var rows: [Row]
    
    
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
    
    func cropImages(cropFaces: Bool, size: CGSize) {
        topLeft?.cropImages(cropFaces: cropFaces, size: size)
        topRight?.cropImages(cropFaces: cropFaces, size: size)
        
        for index in rows.indices {
            rows[index].cropImages(cropFaces: cropFaces, size: size)
        }
    }
}
