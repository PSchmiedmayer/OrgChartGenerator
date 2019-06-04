//
//  OrgChartRenderer.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
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
        let view = try leafRenderer.render(Generator.Constants.orgChartName, context).wait()
        let htmlURL = url.appendingPathComponent("\(Generator.Constants.orgChartName).html", isDirectory: false)
        do {
            try view.data.write(to: htmlURL, options: .atomic)
        } catch {
            throw OrgChartError.couldNotWriteData(to: htmlURL)
        }
        return view.data
    }
}
