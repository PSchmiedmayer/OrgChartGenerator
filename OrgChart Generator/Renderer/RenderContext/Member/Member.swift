//
//  Member.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import OrgChart


struct Member {
    let id: UUID = UUID()
    let name: String
    let role: String?
    private(set) var imageState: ImageState
    
    
    var picture: NSImage? {
        switch imageState {
        case .notLoaded, .cloudNotBeLoaded:
            return nil
        case let .loaded(image), let .cropped(image):
            return image
        }
    }
    
    
    init(name: String, role: String? = nil, imageState: ImageState) {
        self.name = name
        self.role = role
        self.imageState = imageState
    }
    
    init(_ orgChartMember: OrgChartMember) {
        self.init(name: orgChartMember.name,
                  role: orgChartMember.role,
                  imageState: .notLoaded(orgChartMember.picture))
    }
    
    
    mutating func loadImage() {
        guard case let .notLoaded(pictureURL) = imageState,
              let image = NSImage(contentsOfFile: pictureURL.path) else {
            return
        }
        
        imageState = .loaded(image)
    }
}


extension Member: Hashable { }


extension Member: Identifiable { }
