//
//  ImageTransformation.swift
//  ImageProcessor
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import Combine


/// An abstraction for actors that can transfrom an image
public protocol ImageTransformation {
    /// Transform an image based on the input provided to the type conforming to `ImageTransformation`
    /// - Parameter image: The `NSImage` that should be transformed
    func transform(_ image: NSImage) -> AnyPublisher<NSImage, ImageTransformationError>
}
