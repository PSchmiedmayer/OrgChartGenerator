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
        let app = Application(.testing)
        defer { app.shutdown() }

        app.views.use(.leaf)
        app.leaf.cache.isEnabled = false
        app.leaf.files = LeafTemplate()
        
        let context = OrgChartLeafContext(orgChart)
    
        var view = try app.view.render("LeafTemplate", context).wait()
        let htmlURL = url.appendingPathComponent("\(Generator.Constants.orgChartName).html", isDirectory: false)
        
        let readableBytes = view.data.readableBytes
        guard let data: Data = view.data.readData(length: readableBytes) else {
            throw GeneratorError.couldNotWriteData(to: htmlURL)
        }
        try data.write(to: htmlURL, options: .atomic)
        
        return data
    }
}
