//
//  FaceCrop.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Cocoa

var currentProgress: Progress?

func faceCrop(orgChart: OrgChart,
              tempURL: URL?,
              imageSize: Int,
              compression: Double,
              fileType: FileType = .jpeg,
              progress: @escaping (Progress) -> (),
              completion: @escaping (OrgChart) -> ()) {
    
    DispatchQueue.global(qos: .userInitiated).async {
        let imageSize = imageSize ?? 500
        
        let cropImagesCount = orgChart.teams.reduce(0, { $0 + $1.members.values.count })
                              + orgChart.crossTeamRoles.reduce(0, { $0 + $1.management.count })
        
        currentProgress = Progress(totalUnitCount: Int64(cropImagesCount))
        progress(currentProgress!)

        DispatchQueue.concurrentPerform(iterations: cropImagesCount, execute: { index in
            autoreleasepool{
                let imageFileURL = filePaths[index]
                let imageFileNameComponents = imageFileURL.deletingPathExtension().lastPathComponent.split(separator: "^")
                let options = imageFileNameComponents.dropFirst().map({ String(describing: $0).lowercased() })
                let imageFileName = String(describing: imageFileNameComponents.first ?? "image")
                
                var imageFilePathComponents = imageFileURL.pathComponents
                imageFilePathComponents.removeFirst(inputURL.pathComponents.count)
                let outputFileURL = imageFilePathComponents.reduce(outputURL, { $0.appendingPathComponent($1) })
                    .deletingLastPathComponent()
                    .appendingPathComponent(imageFileName, isDirectory: false)
                    .appendingPathExtension(fileType.description)
                
                var imageTransformations: [ImageTransformationType] = []
                if !options.contains("nocrop") {
                    imageTransformations.append(.cropSquareCenteredOnFace)
                }
                imageTransformations.append(ImageTransformationType.scale(toSize: CGSize(width: imageSize, height: imageSize)))
                
                if let image = ImageProcessor.process(imageFromPath: imageFileURL, withTransformations: imageTransformations) {
                    do {
                        let directoryPath = outputFileURL.deletingLastPathComponent().path
                        if !FileManager.default.fileExists(atPath: directoryPath) {
                            try FileManager.default.createDirectory(atPath: directoryPath,
                                                                    withIntermediateDirectories: true,
                                                                    attributes: nil)
                        }
                        try image.imageData(as: fileType, withCompressionFactor: compression).write(to: outputFileURL, options: .atomic)
                    } catch {
                        print("Could not write image \"\(imageFileURL.path)\" to \"\(outputFileURL.path)\" (\(error)")
                    }
                } else {
                    print("Could not image: \"\(imageFileURL.path)\"")
                }
            }
        })

        completion()
    }
}
