//
//  Generator.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/17/19.
//

import Foundation

final class Generator {
    static func generateOrgChart(in path: String, version: String, completion: ((Error?) -> ())?) {
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        do {
            let orgChart = try OrgChart(fromDirectory: url)
            try OrgChartHTMLRenderer.renderHTMLOrgChart(orgChart, in: url)
            
            completion?(nil)
        } catch {
            completion?(error)
        }
    }
}
