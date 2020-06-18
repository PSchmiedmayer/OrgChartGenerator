//
//  CropSquareCenteredOnFaceTransformation.swift
//  ImageProcessor
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import AppKit
import Combine
import Vision


public struct CropSquareCenteredOnFaceTransformation: ImageTransformation {
    public init() { }
    
    
    public func transform(_ image: NSImage) -> AnyPublisher<NSImage, ImageTransformationError> {
        Future { promise in
            guard let ciImage = image.ciImage else {
                promise(.failure(.couldNotConvertFile))
                return
            }
            
            func faceRectanglesRequestCompletionHandler(request: VNRequest, error: Error?) {
                guard let faceObservations = request.results as? [VNFaceObservation],
                      let face = faceObservations.first,
                      let imageRepresentation = image.representations.first else {
                    promise(.success(image))
                    return
                }
                
                let faceRect = CGRect(x: face.boundingBox.origin.x * imageRepresentation.size.width,
                                      y: (face.boundingBox.origin.y + face.boundingBox.height * 0.15) * imageRepresentation.size.height,
                                      width: face.boundingBox.width * imageRepresentation.size.width,
                                      height: (face.boundingBox.height * 1.15) * imageRepresentation.size.height)
                let faceSquareSize = max(faceRect.size.width, faceRect.size.height)
                
                let squareSize = min(min(imageRepresentation.size.width, imageRepresentation.size.height),
                                     faceSquareSize * 1.6)
                let center = CGPoint(x: min(max(faceRect.center.x, squareSize/2), imageRepresentation.size.width - squareSize/2),
                                     y: min(max(faceRect.center.y, squareSize/2), imageRepresentation.size.height - squareSize/2))
                
                promise(.success(image.crop(to: CGRect(center: center, size: squareSize))))
            }
            
            let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: faceRectanglesRequestCompletionHandler)
            let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage)
            
            DispatchQueue.init(label: "CropSquareCenteredOnFaceTransformation", qos: .userInitiated).async {
                do {
                    try imageRequestHandler.perform([faceDetectionRequest])
                } catch {
                    print("⚠️ Could not perform Vision request: \(error)")
                    promise(.failure(.couldNotPerformVisionRequest))
                }
            }
        }.eraseToAnyPublisher()
    }
}
