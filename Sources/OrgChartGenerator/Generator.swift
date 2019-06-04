//
//  Generator.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/17/19.
//

import Foundation

final class Generator {
    enum Constants {
        static let orgChartName = "OrgChart"
    }
    
    static func generateOrgChart(in path: String, version: String, completion: ((OrgChartError?) -> ())?) {
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        do {
            let orgChart = try OrgChart(fromDirectory: url)
            let htmlData = try OrgChartHTMLRenderer.renderHTMLOrgChart(orgChart, in: url)
            guard let htmlString = String(data: htmlData, encoding: .utf8) else {
                throw OrgChartError.unknownError("Could not decode HTML data to String")
            }
            PDFRenderer.render(html: htmlString, baseURL: url, completion: completion)
        } catch let error as OrgChartError {
            completion?(error)
        } catch {
            completion?(OrgChartError.unknownError(error.localizedDescription))
        }
    }
}
