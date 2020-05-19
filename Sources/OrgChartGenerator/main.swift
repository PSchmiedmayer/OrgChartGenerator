//
//  main.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/17/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import ArgumentParser
import Foundation
import SwiftUI


struct OrgChartGenerator: ParsableCommand {
    enum Constants {
        static let orgChartName = "OrgChart"
    }
    
    
    @Argument(help: "The root folder of the directory structure that should be used to generate the OrgChart")
    var path: String
    
    @Option(name: .shortAndLong, default: 500, help: "The size of the quadratic images in the OrgChart should be cropped at.")
    var imageSize: Int
    
    @Option(name: .shortAndLong, default: 0.6, help: "The compresssion rate (1-100) that should be applied to the JEPG images that are rendered in the OrgChart.")
    var compressionRate: Double
    

    func run() throws {
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        let newOrgChartURL = url.appendingPathComponent("\(OrgChartGenerator.Constants.orgChartName)_New.pdf", isDirectory: false)
        struct TestView: View {
            var body: some View {
                VStack {
                    Text("Test Background")
                        .printableBackground(.systemRed)
                    Text("Test Border")
                        .printableBorder(.systemBlue)
                    Text("Test Background + Border")
                        .printableBackground(.systemRed)
                        .printableBorder(.systemBlue, width: 3)
                    PrintableRectangle(color: .systemRed)
                    PrintableBorder(color: .systemBlue, width: 4)
                    PrintableRectangle(color: .systemRed)
                        .printableBorder(.systemTeal, width: 40)
                        .frame(width: 100, height: 100)
                }
            }
        }
        let pdf = Renderer.render(TestView(),
                                  withSize: .init(width: 1920, height: 1080))
        try pdf.write(to: newOrgChartURL)
        
        
        let progress = Progress(totalUnitCount: 100)
        let observation = progress.observe(\.fractionCompleted, changeHandler: { process, _ in
            print("🗂 is \(String(format: "%.1f", process.fractionCompleted * 100))% complete")
        })
        defer {
            observation.invalidate()
        }
        
        // Parse the file structure
        progress.becomeCurrent(withPendingUnitCount: 5)
        let orgChart = try OrgChart(fromDirectory: url)
        progress.resignCurrent()
        
        // Create a temporary directory for the cropped pictures
        let tempURL = url.appendingPathComponent(".pictures", isDirectory: true)
        try? FileManager.default.removeItem(at: tempURL)
        try FileManager.default.createDirectory(at: tempURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
        
        // Crop the Faces
        progress.becomeCurrent(withPendingUnitCount: 85)
        try FaceCrop.crop(orgChart, tempURL: tempURL, imageSize: imageSize, compression: compressionRate)
        progress.resignCurrent()
        
        // Render the HTML of the OrgChart
        progress.becomeCurrent(withPendingUnitCount: 5)
        let htmlData = try OrgChartHTMLRenderer.renderHTMLOrgChart(orgChart, in: url)
        progress.resignCurrent()
        
        // Create a PDF from the HTML
        progress.becomeCurrent(withPendingUnitCount: 4)
        guard let htmlString = String(data: htmlData, encoding: .utf8) else {
            throw GeneratorError.unknownError("Could not decode HTML data to String")
        }
        progress.resignCurrent()
        
        progress.becomeCurrent(withPendingUnitCount: 1)
        PDFRenderer.render(html: htmlString, baseURL: url) { error in
            progress.resignCurrent()
            OrgChartGenerator.exit(withError: error)
        }
        
        RunLoop.main.run()
    }
}


OrgChartGenerator.main()
