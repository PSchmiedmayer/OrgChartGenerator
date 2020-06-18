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


public class TeamHeader: ObservableObject {
    public let background: Background
    
    @Published public private(set) var loading: Bool = false
    @Published public private(set) var imageState: ImageState
    
    private var compressedImage: NSImage?
    private let fallbackName: String
    
    
    public var content: HeaderContent {
        switch imageState {
        case .cloudNotBeLoaded, .notLoaded:
            return .text(fallbackName)
        case let .cropped(image), let .loaded(image):
            return .image(compressedImage ?? image)
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
        DispatchQueue.main.async {
            self.loading = true
        }
        
        if case let .success(image) = imageState.loadImage() {
            DispatchQueue.main.async {
                self.imageState = .loaded(image)
                self.loading = false
            }
        }
    }
}


extension TeamHeader: Equatable {
    public static func == (lhs: TeamHeader, rhs: TeamHeader) -> Bool {
        lhs.background == rhs.background
            && lhs.imageState == rhs.imageState
            && lhs.fallbackName == rhs.fallbackName
        
    }
}


extension TeamHeader: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(background)
        hasher.combine(imageState)
        hasher.combine(fallbackName)
    }
}
