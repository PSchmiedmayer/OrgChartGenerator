//
//  File.swift
//  
//
//  Created by Paul Schmiedmayer on 5/19/20.
//

import ArgumentParser


struct OrgChartGenerator: ParsableCommand {
    @Argument(help: "The root folder of the directory structure that should be used to generate the OrgChart")
    var path: String
    
    @Option(name: .shortAndLong, default: 500, help: "The size of the quadratic images in the OrgChart should be cropped at.")
    var imageSize: Int
    
    @Option(name: .shortAndLong, default: 0.6, help: "The compresssion rate (1-100) that should be applied to the JEPG images that are rendered in the OrgChart.")
    var compressionRate: Double
    

    func run() throws {
        Generator.generateOrgChart(in: path,
                                   imageSize: imageSize,
                                   compressionRate: compressionRate) { error in
            OrgChartGenerator.exit(withError: error)
        }
    }
}
