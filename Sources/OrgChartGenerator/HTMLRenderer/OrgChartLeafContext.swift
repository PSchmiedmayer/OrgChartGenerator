//
//  OrgChartLeafContext.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//

struct OrgChartLeafContext: Codable {
    struct Style: Codable {
        let logo: String
        let background: Background
    }
    
    struct Row: Codable {
        let heading: String?
        let teamMembers: [[OrgChartLeafContext.Member]]
        let management: Box?
    }
    
    struct Member: Codable {
        let name: String
        let picture: String
        let role: String?
    }
    
    struct Box: Codable {
        let title: String?
        let background: Background
        let members: [OrgChartLeafContext.Member]
    }
    
    let title: String
    let topLeft: Box?
    let topRight: Box?
    let teamStyles: [Style]
    let rows: [Row]
    
    init(_ orgChart: OrgChart) {
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
                       teamMembers: orgChart.teams.map({ $0.members[position].map({ $0.map({ $0.member }) }) ?? [] }),
                       management: managementBox)
        })
    }
}

extension CrossTeamRole {
    fileprivate var box: OrgChartLeafContext.Box {
        return OrgChartLeafContext.Box(title: title, background: background, members: management.map({ $0.member }))
    }
}

extension Member {
    fileprivate var member: OrgChartLeafContext.Member {
        return OrgChartLeafContext.Member(name: name, picture: picture.absoluteString, role: role)
    }
}
