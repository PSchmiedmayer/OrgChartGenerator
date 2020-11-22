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
    
    @Published private var compressedImage: NSImage?
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


extension TeamHeader: ImageHandler {
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
    
    func cropImages(cropFaces: Bool, size: CGSize, compressionFactor: CGFloat) -> AnyPublisher<Void, Never> {
        DispatchQueue.main.async {
            self.loading = true
        }
        
        guard let image = imageState.image else {
            return Just(Void()).eraseToAnyPublisher()
        }
        
        return Just(image.compress(compressionFactor: compressionFactor, useHEIF: true) as NSImage?)
            .map { compressedImage in
                DispatchQueue.main.async {
                   self.imageState = .cropped(image)
                   self.compressedImage = compressedImage
                   self.loading = false
                }
            }
            .eraseToAnyPublisher()
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
