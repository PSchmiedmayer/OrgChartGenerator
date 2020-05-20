//
//  OrgChartMock.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import OrgChart
import Foundation

extension OrgChart {
    static let mock: OrgChart = {
        let generator = OrgChartGenerator.init(orgChartName: "OrgChart",
                                               path: URL(fileURLWithPath: "/Users/paulschmiedmayer/Downloads/ios20-orgchart/iPraktikum 2020"))
        generator.parseOrgChart()
        guard let orgChart = generator.state.orgChart else {
            preconditionFailure()
        }
        return orgChart
    }()
}

