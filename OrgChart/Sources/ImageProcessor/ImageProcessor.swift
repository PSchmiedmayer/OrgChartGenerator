//
//  ImageProcessor.swift
//  ImageProcessor
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import Combine


public struct ImageProcessor {
    private var dispatchQueue = DispatchQueue.init(label: "ImageProcessor",
                                                   qos: .userInitiated,
                                                   attributes: .concurrent,
                                                   autoreleaseFrequency: .workItem)
    
    
    public init() { }
    
    
    public func process(imageFromPath path: URL,
                        withTransformations transformations: [ImageTransformation]) -> AnyPublisher<NSImage, ImageTransformationError> {
        
        Future { promise in
                self.dispatchQueue.async {
                    guard let image = NSImage(contentsOfFile: path.path) else {
                        promise(.failure(ImageTransformationError.couldNotLoadFile))
                        return
                    }
                    promise(.success(image))
                }
            }
            .flatMap { image in
                self.process(image, withTransformations: transformations)
            }
            .eraseToAnyPublisher()
    }
    
    public func process(_ image: NSImage,
                        withTransformations transformations: [ImageTransformation]) -> AnyPublisher<NSImage, ImageTransformationError> {
        let progress = Progress(totalUnitCount: Int64(transformations.count))
        
        var publisher = Just(image)
            .setFailureType(to: ImageTransformationError.self)
            .eraseToAnyPublisher()
        
        transformations.first
            .map { transformation in
                publisher = publisher
                    .receive(on: dispatchQueue)
                    .flatMap { image -> AnyPublisher<NSImage, ImageTransformationError> in
                        let publisher = transformation.transform(image)
                        progress.completedUnitCount += 1
                        return publisher
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
