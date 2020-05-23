//
//  Management.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation


struct Management {
    let title: String?
    private(set) var members: [Member]
    
    
    init(title: String? = nil, members: [Member]) {
        self.title = title
        self.members = members
    }
}


extension Management: ImageHandler {
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


extension Management: Hashable { }
