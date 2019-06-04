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
            try OrgChartHTMLRenderer.renderHTMLOrgChart(orgChart, in: url)
            PDFRenderer.renderHTMLOrgChart(foundInURL: url, completion: completion)
        } catch let error as OrgChartError {
            completion?(error)
        } catch {
            completion?(OrgChartError.unknownError(error.localizedDescription))
        }
    }
}
