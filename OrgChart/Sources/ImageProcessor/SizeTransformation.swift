//
//  SizeTransformation.swift
//  ImageProcessor
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import Combine


public struct SizeTransformation: ImageTransformation {
    public let size: CGSize
    
    
    public init(_ size: CGSize) {
        self.size = size
    }
    
    public init(square: Int) {
        self.init(CGSize(width: square, height: square))
    }
    
    
    public func transform(_ image: NSImage) -> AnyPublisher<NSImage, ImageTransformationError> {
        return Future { promise in
            promise(.success(image.scale(toSize: self.size)))
        }.eraseToAnyPublisher()
    }
}
