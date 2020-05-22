//
//  OrgChartGeneratorState.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart


enum OrgChartGeneratorState {
    case initialized
    case pathProvided(path: URL, orgChart: OrgChart)
    case orgChartParsed(path: URL, renderContext: OrgChartRenderContext)
    case imagesCropped(path: URL, renderContext: OrgChartRenderContext)
    case orgChartRendered(path: URL, renderContext: OrgChartRenderContext, pdf: Data)
    
    enum ProcessFraction {
        static let initialized: Int64 = 0
        static let pathProvided: Int64 = 0
        static let orgChartParsed: Int64 = 5
        static let imagesCropped: Int64 = 85
        static let orgChartRendered: Int64 = 10
    }
    
    enum ProcessCompletedUnitCount {
        static let initialized: Int64 = 0
        static let pathProvided: Int64 = ProcessFraction.initialized
        static let orgChartParsed: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided
        static let imagesCropped: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided + ProcessFraction.orgChartParsed
        static let orgChartRendered: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided + ProcessFraction.orgChartParsed + ProcessFraction.imagesCropped
    }
    
    var path: URL? {
        switch self {
        case let .pathProvided(path, _), let .orgChartParsed(path, _), let .imagesCropped(path, _), let .orgChartRendered(path, _, _):
            return path
        case .initialized:
            return nil
        }
    }
    
    var renderContext: OrgChartRenderContext? {
        switch self {
        case let .orgChartParsed(_, renderContext), let .imagesCropped(_, renderContext), let .orgChartRendered(_, renderContext, _):
            return renderContext
        case .initialized, .pathProvided:
            return nil
        }
    }
    
    var pdf: Data? {
        switch self {
        case let .orgChartRendered(_, _, pdf):
            return pdf
        case .initialized, .pathProvided, .orgChartParsed, .imagesCropped:
            return nil
        }
    }
}
