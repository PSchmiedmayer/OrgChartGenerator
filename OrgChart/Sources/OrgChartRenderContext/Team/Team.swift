//
//  OrgChartTeam.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart


class Team: ObservableObject {
    let id: UUID = UUID()
    @Published private(set) var header: TeamHeader
    let background: Background
    
    
    init(_ team: OrgChartTeam) {
        self.header = TeamHeader(team)
        self.background = Background(color: team.background.color.withAlphaComponent(Constants.Team.backgroundAlpha))
    }
}


extension Team: ImageLoadable {
    func loadImages() {
        header.loadImages()
    }
}

extension Team: Equatable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
            && lhs.header == rhs.header
            && lhs.background == rhs.background
        
    }
}


extension Team: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(header)
        hasher.combine(background)
    }
}


extension Team: Identifiable { }
