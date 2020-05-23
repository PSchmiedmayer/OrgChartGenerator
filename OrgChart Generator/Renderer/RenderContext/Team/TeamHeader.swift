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
    let background: Background
    
    private var imageState: ImageState
    private let fallbackName: String
    
    
    var content: HeaderContent {
        switch imageState {
        case .cloudNotBeLoaded, .notLoaded:
            return .text(fallbackName)
        case let .cropped(image), let .loaded(image):
            return .image(image)
        }
    }
    
    
    init(imageState: ImageState, fallbackName: String, background: Background) {
        self.imageState = imageState
        self.fallbackName = fallbackName
        self.background = background
    }
    
    init(_ team: OrgChartTeam) {
        let background = Background(color: team.background.color.withAlphaComponent(Constants.Team.headerBackgroundAlpha))
        
        self.init(imageState: .notLoaded(team.logo),
                  fallbackName: team.name,
                  background: background)
    }
    
    
    mutating func loadImages() {
        guard case let .notLoaded(pictureURL) = imageState,
              let image = NSImage(contentsOfFile: pictureURL.path) else {
            return
        }
        
        self.imageState = .loaded(image)
    }
}


extension TeamHeader: Hashable {}
