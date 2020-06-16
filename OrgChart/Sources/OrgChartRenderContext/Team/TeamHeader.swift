//
//  TeamHeader.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import OrgChart
import Combine


class TeamHeader {
    let background: Background
    
    @Published var loading: Bool = false
    @Published private(set) var imageState: ImageState
    
    private let fallbackName: String
    
    
    var content: HeaderContent {
        switch imageState {
        case .cloudNotBeLoaded, .notLoaded:
            return .text(fallbackName)
        case .cropped, .loaded:
            return .image(imageState)
        }
    }
    
    
    init(imageState: ImageState, fallbackName: String, background: Background) {
        self.imageState = imageState
        self.fallbackName = fallbackName
        self.background = background
    }
    
    convenience init(_ team: OrgChartTeam) {
        let background = Background(color: team.background.color.withAlphaComponent(Constants.Team.headerBackgroundAlpha))
        
        self.init(imageState: .notLoaded(team.logo),
                  fallbackName: team.name,
                  background: background)
    }
}


extension TeamHeader: ImageLoadable {
    func loadImages() {
        loading = true
        
        if case let .success(image) = imageState.loadImage() {
            self.imageState = .loaded(image)
            loading = false
        }
    }
}


extension TeamHeader: Equatable {
    static func == (lhs: TeamHeader, rhs: TeamHeader) -> Bool {
        lhs.background == rhs.background
            && lhs.imageState == rhs.imageState
            && lhs.fallbackName == rhs.fallbackName
        
    }
}


extension TeamHeader: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(background)
        hasher.combine(imageState)
        hasher.combine(fallbackName)
    }
}
