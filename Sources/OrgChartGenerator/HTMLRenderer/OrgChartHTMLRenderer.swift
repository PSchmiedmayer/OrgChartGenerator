//
//  OrgChartRenderer.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Vapor
import Leaf

final class OrgChartHTMLRenderer {    
    static func renderHTMLOrgChart(_ orgChart: OrgChart, in url: URL) throws -> Data {
        // Setup Vapor Services
        var services = Services()
        try services.register(LeafProvider())
        services.register(DirectoryConfig.detect())
        
        // Setup Vapor Application
        let app = try Application(config: Config.default(),
                                  environment: try Environment.detect(),
                                  services: services)
        
        // Setup Vapor Application
        let context = OrgChartLeafContext(orgChart)
        let leafRenderer = try app.make(LeafRenderer.self)
        
        #warning("Replace the logic to find the resource once Swift Package Manager supports resouces: https://bugs.swift.org/browse/SR-2866")
        var templatePath =  URL(fileURLWithPath: #file)
        while templatePath.lastPathComponent != "Sources" || templatePath.pathComponents.isEmpty {
            templatePath.deleteLastPathComponent()
        }
        templatePath.deleteLastPathComponent()
        templatePath.appendPathComponent("Resources/Views/", isDirectory: true)
        templatePath.appendPathComponent("\(Generator.Constants.orgChartName).leaf", isDirectory: false)
        
        let view = try leafRenderer.render(templatePath.relativePath, context).wait()
        let htmlURL = url.appendingPathComponent("\(Generator.Constants.orgChartName).html", isDirectory: false)
        do {
            try view.data.write(to: htmlURL, options: .atomic)
        } catch {
            throw GeneratorError.couldNotWriteData(to: htmlURL)
        }
        return view.data
    }
}
