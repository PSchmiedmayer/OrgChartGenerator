//
//  ImageTransformationError.swift
//  ImageProcessor
//
//  Created by Paul Schmiedmayer on 5/22/20.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

public enum ImageTransformationError: Error {
    case couldNotLoadFile
    case couldNotConvertFile
    case couldNotPerformVisionRequest
}
