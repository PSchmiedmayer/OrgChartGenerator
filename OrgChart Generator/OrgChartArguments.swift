//
//  OrgChartArguments.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/24/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import ArgumentParser


struct OrgChartArguments: ParsableCommand {
    @Argument(help: "The root folder of the directory structure that should be used to generate the OrgChart")
    var path: String
    
    @Option(name: .shortAndLong, default: OrgChartGeneratorSettings.Defaults.orgChartName, help: "The name of the OrgChart PDF that should be generated.")
    var orgChartName: String

    @Option(name: .shortAndLong, default: OrgChartGeneratorSettings.Defaults.imageSize, help: "The size of the quadratic images in the OrgChart should be cropped at.")
    var imageSize: Int

    @Option(name: .shortAndLong, default: Double(OrgChartGeneratorSettings.Defaults.compressionFactor), help: "The compresssion rate (1-100) that should be applied to the JEPG images that are rendered in the OrgChart.")
    var compressionFactor: Double
    
    @Flag(default: OrgChartGeneratorSettings.Defaults.cropFaces, inversion: .prefixedEnableDisable, help: "Crop the images of the members of the OrgChart so thier faces are centered")
    var cropFaces: Bool
    
    @Flag(default: true, inversion: .prefixedNo, help: "Autogenerate the OrgChart without user interaction needed and exit the application when the PDF was exported")
    var autogenerate: Bool
}

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(string: argument)
    }

    public var defaultValueDescription: String {
        "FilePath"
    }
}
