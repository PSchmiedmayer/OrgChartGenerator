//
//  OrgChartRenderContext.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import OrgChart


struct OrgChartRenderContext {
    struct Style: Hashable {
        let logo: String
        let background: Background
    }
    
    struct Row: Hashable {
        let heading: String?
        let background: Background?
        let teamMembers: [[OrgChartRenderContext.Member]]
        let management: Box?
    }
    
    struct Member: Hashable {
        let name: String
        let picture: String
        let role: String?
    }
    
    struct Box: Hashable {
        let title: String?
        let background: Background
        let members: [OrgChartRenderContext.Member]
    }
    
    
    let title: String
    let topLeft: Box?
    let topRight: Box?
    let teamStyles: [Style]
    let rows: [Row]
    
    
    fileprivate init(_ orgChart: OrgChart) {
        self.title = orgChart.title
        self.topLeft = orgChart.crossTeamRoles.first(where: { $0.position == .topLeft })?.box
        self.topRight = orgChart.crossTeamRoles.first(where: { $0.position == .topRight })?.box
        self.teamStyles = orgChart.teams.map({ Style(logo: $0.logo.absoluteString, background: $0.background) })
        let positions = Set(orgChart.teams.flatMap({ $0.members.keys })).sorted()
        self.rows = positions.map({ position in
            let crossTeamRole = orgChart.crossTeamRoles.first(where: { $0.position == position })
            let managementBox = crossTeamRole.flatMap({
                Box(title: $0.title,
                    background: $0.background,
                    members: $0.management.map({ $0.member }))
            })
            return Row(heading: crossTeamRole?.heading,
                       background: crossTeamRole?.background,
                       teamMembers: orgChart.teams.map({ $0.members[position].map({ $0.map({ $0.member }) }) ?? [] }),
                       management: managementBox)
        })
    }
}

extension OrgChart {
    var renderContext: OrgChartRenderContext {
        OrgChartRenderContext(self)
    }
}

extension CrossTeamRole {
    fileprivate var box: OrgChartRenderContext.Box {
        OrgChartRenderContext.Box(title: title, background: background, members: management.map({ $0.member }))
    }
}

extension Member {
    fileprivate var member: OrgChartRenderContext.Member {
        OrgChartRenderContext.Member(name: name, picture: picture.absoluteString, role: role)
    }
}
