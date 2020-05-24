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
    case imagesLoaded(path: URL, renderContext: OrgChartRenderContext)
    case imagesCropped(path: URL, renderContext: OrgChartRenderContext)
    case orgChartRendered(path: URL, renderContext: OrgChartRenderContext, pdf: Data)
    
    enum ProcessFraction {
        static let initialized: Int64 = 0
        static let pathProvided: Int64 = 2
        static let orgChartParsed: Int64 = 3
        static let imagesLoaded: Int64 = 10
        static let imagesCropped: Int64 = 75
        static let orgChartRendered: Int64 = 10
    }
    
    enum ProcessCompletedUnitCount {
        static let initialized: Int64 = 0
        static let pathProvided: Int64 = ProcessFraction.initialized
        static let orgChartParsed: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided
        static let imagesLoaded: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided
                                             + ProcessFraction.orgChartParsed
        static let imagesCropped: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided
                                             + ProcessFraction.orgChartParsed  + ProcessFraction.imagesLoaded
        static let orgChartRendered: Int64 = ProcessFraction.initialized + ProcessFraction.pathProvided
                                             + ProcessFraction.orgChartParsed + ProcessFraction.imagesLoaded
                                             + ProcessFraction.imagesCropped
    }
    
    var path: URL? {
        switch self {
        case let .pathProvided(path, _), let .orgChartParsed(path, _), let .imagesLoaded(path, _),
             let .imagesCropped(path, _), let .orgChartRendered(path, _, _):
            return path
        case .initialized:
            return nil
        }
    }
    
    var renderContext: OrgChartRenderContext? {
        get {
            switch self {
            case let .orgChartParsed(_, renderContext), let .imagesLoaded(_, renderContext), let .imagesCropped(_, renderContext),
                 let .orgChartRendered(_, renderContext, _):
                return renderContext
            case .initialized, .pathProvided:
                return nil
            }
        }
    }
    
    var pdf: Data? {
        switch self {
        case let .orgChartRendered(_, _, pdf):
            return pdf
        case .initialized, .pathProvided, .orgChartParsed, .imagesLoaded, .imagesCropped:
            return nil
        }
    }
    
    static func set(renderContext: OrgChartRenderContext, on state: Self) -> Self {
        switch state {
        case .pathProvided, .initialized:
            return state
        case let .orgChartParsed(path, _):
            return .orgChartParsed(path: path, renderContext: renderContext)
        case let .imagesLoaded(path, _):
            return .imagesLoaded(path: path, renderContext: renderContext)
        case let .imagesCropped(path, _):
            return .imagesCropped(path: path, renderContext: renderContext)
        case let .orgChartRendered(path, _, pdf):
            return .orgChartRendered(path: path, renderContext: renderContext, pdf: pdf)
        }
    }
}
