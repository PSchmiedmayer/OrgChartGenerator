//
//  Member.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import Combine
import OrgChart
import ImageProcessor


class Member: ObservableObject {
    let id: UUID = UUID()
    let name: String
    let role: String?
    @Published var imageState: ImageState
    @Published var loading: Bool = false
    
    
    var picture: NSImage? {
        imageState.image
    }
    
    
    init(name: String, role: String? = nil, imageState: ImageState) {
        self.name = name
        self.role = role
        self.imageState = imageState
    }
    
    convenience init(_ orgChartMember: OrgChartMember) {
        self.init(name: orgChartMember.name,
                  role: orgChartMember.role,
                  imageState: .notLoaded(orgChartMember.picture))
    }
}


extension Member: ImageHandler {
    func loadImages() {
        loading = true
        if case let .success(image) = imageState.loadImage() {
            self.imageState = .loaded(image)
            loading = false
        }
    }
    
    func cropImages(cropFaces: Bool, size: CGSize)  -> AnyPublisher<Void, Never> {
        loading = true
        return Just(Void())
            .flatMap { _ in
                self.imageState
                    .cropImages(cropFaces: cropFaces, size: size)
                    .map { image in
                        self.imageState = .cropped(image)
                        self.loading = false
                    }
                    .replaceError(with: Void())
            }
            .eraseToAnyPublisher()
    }
}

extension Member: Equatable {
    static func == (lhs: Member, rhs: Member) -> Bool {
        lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.role == rhs.role
            && lhs.imageState == rhs.imageState
        
    }
}


extension Member: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(role)
        hasher.combine(imageState)
    }
}


extension Member: Identifiable { }
