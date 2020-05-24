//
//  OrgChartGeneratorSettings.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/24/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation


class OrgChartGeneratorSettings: ObservableObject {
    private enum Defaults {
        static let orgChartName: String = "OrgChart"
        static let imageSize: Int = 250
        static let compressionRate: Double = 0.6
        static let cropFaces: Bool = true
        static let exitOnPDFExport: Bool = false
    }
    
    
    @Published var path: URL?
    @Published var orgChartName: String
    @Published var imageSize: Int
    @Published var compressionRate: Double
    @Published var cropFaces: Bool
    @Published var exitOnPDFExport: Bool
    
    
    init(path: URL?,
         orgChartName: String = Defaults.orgChartName,
         imageSize: Int = Defaults.imageSize,
         compressionRate: Double = Defaults.compressionRate,
         cropFaces: Bool = Defaults.cropFaces,
         exitOnPDFExport: Bool = Defaults.exitOnPDFExport) {
        self.orgChartName = orgChartName
        self.imageSize = imageSize
        self.compressionRate = compressionRate
        self.cropFaces = cropFaces
        self.exitOnPDFExport = exitOnPDFExport
    }
    
    convenience init() {
        do {
            let arguments = try OrgChartArguments.parse()
            self.init(path: arguments.path,
                      orgChartName: arguments.orgChartName,
                      imageSize: arguments.imageSize,
                      compressionRate: arguments.compressionRate,
                      cropFaces: arguments.cropFaces,
                      exitOnPDFExport: arguments.exitOnPDFExport)
        } catch {
            print("Could not be loaded from the launch arguments. Using the default values.")
            print(OrgChartArguments.helpMessage())
            self.init(path: nil)
        }
    }
}
