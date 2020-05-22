//
//  ImageTransformation.swift
//  ImageProcessor
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import Combine


public protocol ImageTransformation {
    func transform(_ image: NSImage) -> AnyPublisher<NSImage, ImageTransformationError>
}
