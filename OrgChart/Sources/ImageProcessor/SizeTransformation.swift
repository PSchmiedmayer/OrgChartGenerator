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
    
    
    init(_ size: CGSize) {
        self.size = size
    }
    
    init(_ size: Int) {
        self.init(CGSize(width: size, height: size))
    }
    
    
    public func transform(_ image: NSImage) -> AnyPublisher<NSImage, ImageTransformationError> {
        Future { promise in
            promise(.success(image.scale(toSize: self.size)))
        }.eraseToAnyPublisher()
    }
}
