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
        var services = Services()
        
        services.register(DirectoryConfig.detect())
        
        // BlockingIOThreadPool
        let sharedThreadPool = BlockingIOThreadPool(numberOfThreads: 1)
        sharedThreadPool.start()
        services.register(sharedThreadPool)
        
        // DirectoryConfig
        services.register(ViewRenderer.self) { container -> PlaintextRenderer in
            let dir = try container.make(DirectoryConfig.self)
            print(dir.workDir)
            return PlaintextRenderer.init(viewsDir: dir.workDir, on: container)
        }
        
        // Leaf
        try services.register(LeafProvider())
        
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
