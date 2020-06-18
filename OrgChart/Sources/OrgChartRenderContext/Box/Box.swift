//
//  Box.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart
import Combine


public class Box: ObservableObject {
    public let id: UUID = UUID()
    public let title: String?
    public let background: Background?
    @Published public private(set) var members: [Member]
    
    
    init(title: String? = nil, background: Background? = nil, members: [Member]) {
        self.title = title
        self.background = background
        self.members = members
    }
    
    convenience init(_ crossTeamRole: CrossTeamRole) {
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
    
    func cropImages(cropFaces: Bool, size: CGSize, compressionFactor: CGFloat) -> AnyPublisher<Void, Never> {
        let publishers = members.indices
            .map { index in
                members[index].cropImages(cropFaces: cropFaces, size: size, compressionFactor: compressionFactor)
            }
        return Publishers.MergeMany(publishers)
            .collect()
            .map { _ in }
            .eraseToAnyPublisher()
    }
}


extension Box: Equatable {
    public static func == (lhs: Box, rhs: Box) -> Bool {
        lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.background == rhs.background
            && lhs.members == rhs.members
        
    }
}


extension Box: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(background)
        hasher.combine(members)
    }
}



extension Box: Identifiable { }
