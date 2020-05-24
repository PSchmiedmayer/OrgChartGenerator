//
//  Box.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart

struct Box {
    let id: UUID = UUID()
    let title: String?
    let background: Background?
    var members: [Member]
    
    
    init(title: String? = nil, background: Background? = nil, members: [Member]) {
        self.title = title
        self.background = background
        self.members = members
    }
    
    init(_ crossTeamRole: CrossTeamRole) {
        let color = crossTeamRole.background.color
        let background = Background(color: color.withAlphaComponent(Constants.Box.backgroundAlpha),
                                    border: Border(color: color.withAlphaComponent(Constants.Box.borderAlpha),
                                                   width: Constants.Box.borderWidth))
        let members = crossTeamRole.management.map { Member($0) }
        
        self.init(title: crossTeamRole.title,
                  background: background,
                  members: members)
    }
}


extension Box: ImageHandler {
    func loadImages() {
        for index in members.indices {
            members[index].loadImages()
        }
    }
    
    func cropImages(cropFaces: Bool, size: CGSize) {
        for index in members.indices {
            members[index].cropImages(cropFaces: cropFaces, size: size)
        }
    }
}


extension Box: Hashable { }


extension Box: Identifiable { }
