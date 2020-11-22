//
//  OrgChartTeam.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart
import Combine


public class Team: ObservableObject {
    public let id = UUID()
    @Published public private(set) var header: TeamHeader
    public let background: Background
    
    
    init(_ team: OrgChartTeam) {
        self.header = TeamHeader(team)
        self.background = Background(color: team.background.color.withAlphaComponent(Constants.Team.backgroundAlpha))
    }
}


extension Team: ImageHandler {
    func loadImages() {
        header.loadImages()
    }
    
    func cropImages(cropFaces: Bool, size: CGSize, compressionFactor: CGFloat) -> AnyPublisher<Void, Never> {
        header.cropImages(cropFaces: cropFaces, size: size, compressionFactor: compressionFactor)
    }
}

extension Team: Equatable {
    public static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
            && lhs.header == rhs.header
            && lhs.background == rhs.background
    }
}


extension Team: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(header)
        hasher.combine(background)
    }
}


extension Team: Identifiable { }
