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
    case pathProvided(path: URL)
    case orgChartParsed(path: URL, orgChart: OrgChart)
    case facesCropped(path: URL, orgChart: OrgChart)
    case orgChartRendered(path: URL, orgChart: OrgChart, pdf: Data)
    
    enum ProcessFraction {
        static let initialized: Int64 = 0
        static let pathProvided: Int64 = 0
        static let orgChartParsed: Int64 = 5
        static let facesCropped: Int64 = 85
        static let orgChartRendered: Int64 = 10
    }
    
    enum ProcessCompletedUnitCount {
        static let initialized: Int64 = 0
        static let pathProvided: Int64 = ProcessFraction.initialized
        static let orgChartParsed: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided
        static let facesCropped: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided + ProcessFraction.orgChartParsed
        static let orgChartRendered: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided + ProcessFraction.orgChartParsed + ProcessFraction.facesCropped
    }
    
    var path: URL? {
        switch self {
        case let .pathProvided(path), let .orgChartParsed(path, _), let .facesCropped(path, _), let .orgChartRendered(path, _, _):
            return path
        case .initialized:
            return nil
        }
    }
    
    var orgChart: OrgChart? {
        switch self {
        case let .orgChartParsed(_, orgChart), let .facesCropped(_, orgChart), let .orgChartRendered(_, orgChart, _):
            return orgChart
        case .initialized, .pathProvided:
            return nil
        }
    }
    
    var pdf: Data? {
        switch self {
        case let .orgChartRendered(_, _, pdf):
            return pdf
        case .initialized, .pathProvided, .orgChartParsed, .facesCropped:
            return nil
        }
    }
}
