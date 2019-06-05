//
//  Generator.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/17/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation

final class Generator {
    enum Constants {
        static let orgChartName = "OrgChart"
    }
    
    static func generateOrgChart(in path: String, version: String, completion: ((GeneratorError?) -> ())?) {
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        do {
            let orgChart = try OrgChart(fromDirectory: url)
            let htmlData = try OrgChartHTMLRenderer.renderHTMLOrgChart(orgChart, in: url)
            guard let htmlString = String(data: htmlData, encoding: .utf8) else {
                throw GeneratorError.unknownError("Could not decode HTML data to String")
            }
            PDFRenderer.render(html: htmlString, baseURL: url, completion: completion)
        } catch let error as GeneratorError {
            completion?(error)
        } catch {
            completion?(GeneratorError.unknownError(error.localizedDescription))
        }
    }
}
