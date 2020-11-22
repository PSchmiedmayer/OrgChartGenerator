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


public class Member: ObservableObject {
    public let id = UUID()
    public let name: String
    public let role: String?
    @Published public var imageState: ImageState
    @Published public var loading: Bool = false
    @Published private var compressedImage: NSImage?
    
    public var picture: NSImage? {
        get {
            compressedImage ?? imageState.image
        }
        // swiftlint:disable:next unused_setter_value
        set {}
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
        
        return Just(Void())
            .flatMap { _ in
                self.imageState
                    .cropImages(cropFaces: cropFaces, size: size)
                    .map { image in
                        let compressedImage: NSImage? = image.compress(compressionFactor: compressionFactor)
                        DispatchQueue.main.async {
                            self.imageState = .cropped(image)
                            self.compressedImage = compressedImage
                            self.loading = false
                        }
                    }
                    .replaceError(with: Void())
            }
            .eraseToAnyPublisher()
    }
}

extension Member: Equatable {
    public static func == (lhs: Member, rhs: Member) -> Bool {
        lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.role == rhs.role
            && lhs.imageState == rhs.imageState
    }
}


extension Member: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(role)
        hasher.combine(imageState)
    }
}


extension Member: Identifiable { }
