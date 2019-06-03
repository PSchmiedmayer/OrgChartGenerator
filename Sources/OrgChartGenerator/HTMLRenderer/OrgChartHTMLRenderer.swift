//
//  OrgChartRenderer.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//

import Vapor
import Leaf

final class OrgChartHTMLRenderer {
    enum Constants {
        static let orgChartName = "OrgChart"
    }
    
    static func renderHTMLOrgChart(_ orgChart: OrgChart, in url: URL) throws {
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
        let view = try leafRenderer.render("OrgChart", context).wait()
        try view.data.write(to: url.appendingPathComponent("OrgChart.html", isDirectory: false), options: .atomic)
    }
}
