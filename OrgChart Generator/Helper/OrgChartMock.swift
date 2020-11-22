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
        guard let orgChart = try? OrgChart(fromDirectory: URL(fileURLWithPath: "")) else {
            fatalError("You need to enter a valid file path to an OrgChart on your disk.")
        }
        let renderContext = OrgChartRenderContext(orgChart)
        return renderContext
    }()
}
