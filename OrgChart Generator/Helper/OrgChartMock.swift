//
//  OrgChartMock.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart
import OrgChartRenderContext


extension OrgChartRenderContext {
    static let mock: OrgChartRenderContext = {
        let orgChart = try! OrgChart(fromDirectory: URL(fileURLWithPath: "/Users/paulschmiedmayer/Downloads/ios1920-orgchart/iPraktikum 2019-20"))
        let renderContext = OrgChartRenderContext(orgChart)
        return renderContext
    }()
}

