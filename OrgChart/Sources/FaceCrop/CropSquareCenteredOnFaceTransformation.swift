//
//  CropSquareCenteredOnFaceTransformation.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Cocoa
import Vision

class CropSquareCenteredOnFaceTransformation {
    static func process(_ image: NSImage, completion: @escaping (NSImage) -> ()) {
        autoreleasepool{
            guard let ciImage = image.ciImage else {
                completion(image)
                return
            }
            
            func faceRectanglesRequestCompletionHandler(request: VNRequest, error: Error?) {
                guard let faceObservations = request.results as? [VNFaceObservation],
                    let face = faceObservations.first else {
                        completion(image)
                        return
                }
                
                let faceRect = CGRect(x: face.boundingBox.origin.x * image.size.width,
                                      y: (face.boundingBox.origin.y + face.boundingBox.height * 0.15) * image.size.height,
                                      width: face.boundingBox.width * image.size.width,
                                      height: (face.boundingBox.height * 1.15) * image.size.height)
                let faceSquareSize = max(faceRect.size.width, faceRect.size.height)
                
                let squareSize = min(min(image.size.width, image.size.height),
                                     faceSquareSize * 1.6)
                let center = CGPoint(x: min(max(faceRect.center.x, squareSize/2), image.size.width - squareSize/2),
                                     y: min(max(faceRect.center.y, squareSize/2), image.size.height - squareSize/2))
                
                completion(image.crop(CGRect(center: center,
                                             size: squareSize)))
            }
            
            let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: faceRectanglesRequestCompletionHandler)
            let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try imageRequestHandler.perform([faceDetectionRequest])
            } catch {
                print("Could not detect face: \(error)")
                completion(image)
            }
        }
    }
}
