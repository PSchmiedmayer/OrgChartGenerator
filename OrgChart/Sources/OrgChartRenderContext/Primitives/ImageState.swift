//
//  ImageState.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/23/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import ImageProcessor
import Combine


public enum ImageStateError: Error {
    case couldNotBeLoaded
}

public enum ImageState: Hashable {
    case notLoaded(URL)
    case cloudNotBeLoaded
    case loaded(NSImage)
    case cropped(NSImage)
    
    
    public var image: NSImage? {
        switch self {
        case .notLoaded, .cloudNotBeLoaded:
            return nil
        case let .loaded(image), let .cropped(image):
            return image
        }
    }
    
    
    func loadImage() -> Result<NSImage, Error> {
        if let image = self.image {
            return .success(image)
        }
        
        guard case let .notLoaded(pictureURL) = self,
              let image = NSImage(contentsOfFile: pictureURL.path) else {
                return .failure(ImageStateError.couldNotBeLoaded)
        }
        
        return .success(image)
    }
    
    static var cropImagesCount: Int = 0
    
    func cropImages(cropFaces: Bool, size: CGSize) -> AnyPublisher<NSImage, ImageTransformationError> {
        if case let .cropped(image) = self {
            return Just(image)
                .setFailureType(to: ImageTransformationError.self)
                .eraseToAnyPublisher()
        }
        
        guard case let .loaded(image) = self else {
            return Fail(outputType: NSImage.self, failure: ImageTransformationError.couldNotLoadFile)
                .eraseToAnyPublisher()
        }
        
        let transformations: [ImageTransformation]
        if cropFaces {
            transformations = [
                CropSquareCenteredOnFaceTransformation(),
                SizeTransformation(size)
            ]
        } else {
            transformations = [
                SizeTransformation(size)
            ]
        }
        
        return ImageProcessor()
            .process(image, withTransformations: transformations)
            .eraseToAnyPublisher()
    }
}
