//
//  TeamHeader.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import OrgChart


struct TeamHeader {
    let content: HeaderContent
    let background: Background
    
    init(content: HeaderContent, background: Background) {
        self.content = content
        self.background = background
    }
    
    init(_ team: OrgChartTeam) {
        let background = Background(color: team.background.color.withAlphaComponent(Constants.Team.headerBackgroundAlpha))
        
        guard let image = NSImage(contentsOfFile: team.logo.path) else {
            self.init(content: .text(team.name), background: background)
            return
        }
        
        self.init(content: .image(image), background: background)
    }
}


extension TeamHeader: Hashable {}
