//
//  OrgChartGeneratorSettings.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/24/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import ArgumentParser


class OrgChartGeneratorSettings: ObservableObject {
    enum Defaults {
        static let orgChartName: String = "OrgChart"
        static let imageSize: Int = 500
        static let compressionFactor: CGFloat = 0.5
        static let cropFaces: Bool = true
    }
    
    
    @Published var path: URL?
    @Published var orgChartName: String
    @Published var imageSize: Int
    @Published var compressionFactor: CGFloat
    @Published var cropFaces: Bool
    @Published var autogenerate: Bool
    
    
    init(path: URL?,
         orgChartName: String = Defaults.orgChartName,
         imageSize: Int = Defaults.imageSize,
         compressionFactor: CGFloat = Defaults.compressionFactor,
         cropFaces: Bool = Defaults.cropFaces,
         autogenerate: Bool = false) {
        self.path = path
        self.orgChartName = orgChartName
        self.imageSize = imageSize
        self.compressionFactor = compressionFactor
        self.cropFaces = cropFaces
        self.autogenerate = autogenerate
    }
    
    convenience init() {
        var arguments = CommandLine.arguments
        arguments.removeFirst()
        arguments.removeAll(where: { $0 == "-NSDocumentRevisionsDebugMode" }) // Default if running in XCode
        arguments.removeAll(where: { $0 == "YES" }) // Default if running in XCode
        
        let parsedArguments = OrgChartArguments.parseOrExit(arguments)
        
        self.init(path: parsedArguments.path.map { URL(fileURLWithPath: $0) },
                  orgChartName: parsedArguments.orgChartName,
                  imageSize: parsedArguments.imageSize,
                  compressionFactor: CGFloat(parsedArguments.compressionFactor),
                  cropFaces: parsedArguments.cropFaces,
                  autogenerate: parsedArguments.path == nil ? false : parsedArguments.autogenerate)
    }
}
