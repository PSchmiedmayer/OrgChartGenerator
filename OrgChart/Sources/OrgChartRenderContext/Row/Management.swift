//
//  Management.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import Combine


public class Management: ObservableObject {
    public let title: String?
    @Published public private(set) var members: [Member]
    
    
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
    
    func cropImages(cropFaces: Bool, size: CGSize) -> AnyPublisher<Void, Never> {
        let publisher = members.indices
            .map { index in
                members[index].cropImages(cropFaces: cropFaces, size: size)
            }
        return Publishers.MergeMany(publisher)
            .collect()
            .map { _ in }
            .eraseToAnyPublisher()
    }
}


extension Management: Equatable {
    public static func == (lhs: Management, rhs: Management) -> Bool {
        lhs.title == rhs.title
            && lhs.members == rhs.members
        
    }
}


extension Management: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(members)
    }
}
