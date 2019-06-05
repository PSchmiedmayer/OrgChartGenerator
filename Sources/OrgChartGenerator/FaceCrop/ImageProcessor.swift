//
//  ImageProcessor.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Cocoa

enum ImageTransformationType {
    case cropSquareCenteredOnFace
    case scale(toSize: CGSize)
    
    var transformation: (NSImage, @escaping (NSImage) -> ()) -> () {
        switch self {
        case .cropSquareCenteredOnFace:
            return CropSquareCenteredOnFaceTransformation.process
        case let .scale(toSize: size):
            return SizeTransformation.createProcess(forSize: size)
        }
    }
}

final class ImageProcessor {
    
    static func process(imageFromPath path: URL, withTransformations transformations: [ImageTransformationType] = []) -> NSImage? {
        guard let image = NSImage(contentsOfFile: path.path) else {
            return nil
        }
        return process(image: image, withTransformations: transformations)
    }
    
    static func process(image: NSImage, withTransformations transformations: [ImageTransformationType] = []) -> NSImage {
        
        let progress = Progress(totalUnitCount: Int64(transformations.count))
        
        var image = image
        transformations.first.map({ transformationType in
            func handle(result: NSImage) {
                progress.completedUnitCount += 1
                if !progress.isFinished {
                    transformations[Int(progress.completedUnitCount)].transformation(result, handle)
                } else {
                    image = result
                }
            }
            
            transformationType.transformation(image, handle)
        })
        
        return image
    }
}
