//
//  main.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/17/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Utility
import Logging
import Foundation

var log = PrintLogger()

private let parser = ArgumentParser(usage: "-p <path>",
                                    overview: "🗂 OrgChart Generator - Generate an OrgChart from the given directory structure.")

// <options>
private let pathOption = parser.add(option: "--path",
                                    shortName: "-p",
                                    kind: String.self,
                                    usage: "The root folder of the directory structure that should be used to generate the OrgChart",
                                    completion: .filename)
private let imageSizeOption = parser.add(option: "--imageSize",
                                         shortName: "-i",
                                         kind: Int.self,
                                         usage: "The size of the quadratic images in the OrgChart should be cropped at. The default value is 500 pixels",
                                         completion: nil)
private let compressionRateOption = parser.add(option: "--compressionRate",
                                               shortName: "-c",
                                               kind: Int.self,
                                               usage: "The compresssion rate (1-100) that should be applied to the JEPG images that are rendered in the OrgChart. The default value is 60%",
                                               completion: nil)

// The first argument specifies the path of the executable file
private let arguments = Array(CommandLine.arguments.dropFirst()) // Drop first and convert to Array<String>
do {
    let result = try parser.parse(arguments) // Parse arguments
    guard let path = result.get(pathOption) else {
        throw ArgumentParserError.expectedValue(option: "--path")
    }
    let imageSize = result.get(imageSizeOption) ?? 500
    let compressionRate = result.get(compressionRateOption) ?? 60
    guard 1...100 ~= compressionRate else {
        throw ArgumentParserError.expectedValue(option: "--compressionRate must be between 1 and 100")
    }
    
    
    Generator.generateOrgChart(in: path, imageSize: imageSize, compressionRate: Double(compressionRate)/100.0) { error in
        defer {
            exit(0)
        }
        
        if let error = error {
            log.error(error.localizedDescription)
            return
        }
        
        print("🗂 Generated the OrgChart")
    }
    
    RunLoop.main.run()
} catch let error as ArgumentParserError {
    print(error.description)
} catch let error {
    print(error.localizedDescription)
}
