//
//  ImageProcessor.swift
//  ImageProcessor
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import Combine


/// A structure used to process images using `ImageTransformation`s
public struct ImageProcessor {
    /// Create an ImageProcessor
    public init() { }
    
    
    /// Processes an image found at a path with the specifeid `ImageTransformation`s
    /// - Parameters:
    ///   - path: The path the image should be loaded from
    ///   - transformations: The `ImageTransformation`s that should be applied to the image
    /// - Returns: Returns a publisher to observe the asyncrinous taks of transforming an image
    public func process(imageFromPath path: URL,
                        withTransformations transformations: [ImageTransformation]) -> AnyPublisher<NSImage, ImageTransformationError> {
        Future { promise in
                guard let image = NSImage(contentsOfFile: path.path) else {
                    promise(.failure(ImageTransformationError.couldNotLoadFile))
                    return
                }
                promise(.success(image))
        }
            .flatMap { image in
                self.process(image, withTransformations: transformations)
            }
            .eraseToAnyPublisher()
    }
    
    /// Processes an image with the specifeid `ImageTransformation`s
    /// - Parameters:
    ///   - path: The image that should be transformed
    ///   - transformations: The `ImageTransformation`s that should be applied to the image
    /// - Returns: Returns a publisher to observe the asyncrinous taks of transforming an image
    public func process(_ image: NSImage,
                        withTransformations transformations: [ImageTransformation]) -> AnyPublisher<NSImage, ImageTransformationError> {
        let progress = Progress(totalUnitCount: Int64(transformations.count))
        
        var publisher = Just(image)
            .setFailureType(to: ImageTransformationError.self)
            .eraseToAnyPublisher()
        
        transformations
            .forEach { transformation in
                publisher = publisher
                    .flatMap { image -> AnyPublisher<NSImage, ImageTransformationError> in
                        transformation.transform(image)
                            .map { image in
                                progress.completedUnitCount += 1
                                return image
                            }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
        
        publisher = publisher
            .map { image in
                progress.completedUnitCount = progress.totalUnitCount
                return image
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
}
