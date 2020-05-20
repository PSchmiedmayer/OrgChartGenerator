//
//  OrgChartGenerator.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart
import FaceCrop
import Combine

class OrgChartGenerator: ObservableObject {
    private enum Defaults {
        static let orgChartName: String = "OrgChart"
        static let path: URL? = nil
        static let imageSize: Int = 500
        static let compressionRate: Double = 0.6
    }
    
    
    @Published var orgChartName: String
    @Published var imageSize: Int
    @Published var compressionRate: Double
    @Published var state: OrgChartGeneratorState = .initialized
    @Published var fractionCompleted: Double = 0.0
    
    private var progress: Progress
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(orgChartName: String = Defaults.orgChartName,
         path: URL? = Defaults.path,
         imageSize: Int = Defaults.imageSize,
         compressionRate: Double = Defaults.compressionRate) {
        self.orgChartName = orgChartName
        self.imageSize = imageSize
        self.compressionRate = compressionRate
        
        if let path = path {
            self.state = .pathProvided(path: path)
        }
        
        self.progress = Progress(totalUnitCount: 100)
        progress.publisher(for: \.fractionCompleted)
            .sink { fractionCompleted in
                self.fractionCompleted = fractionCompleted
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    
    func parseOrgChart() -> Result<Void, OrgChartError> {
        guard let path = state.path else {
            preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that does not include a path")
        }
        
        progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.pathProvided
        progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.orgChartParsed)
        defer {
            progress.resignCurrent()
        }
        
        do {
            self.state = .orgChartParsed(path: path, orgChart: try OrgChart(fromDirectory: path))
            return .success(Void())
        } catch let error as OrgChartError {
            return .failure(error)
        } catch {
            return .failure(OrgChartError.couldNotReadData(from: path))
        }
    }

    func cropFaces() -> Result<Void, FaceCropError> {
        guard let orgChart = state.orgChart, let path = state.path else {
            preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that does not include a path and an OrgChart")
        }
        
        progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.pathProvided
        progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.orgChartParsed)
        defer {
            progress.resignCurrent()
        }
        
        let tempURL = path.appendingPathComponent(".pictures", isDirectory: true)
        do {
            try? FileManager.default.removeItem(at: tempURL)
            try FileManager.default.createDirectory(at: tempURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
            try orgChart.crop(withTempURL: tempURL, imageSize: imageSize, compression: compressionRate)
            self.state = .facesCropped(path: path, orgChart: orgChart)
            return .success(Void())
        } catch let error as FaceCropError {
            return .failure(error)
        } catch {
            return .failure(FaceCropError.couldNotWriteData(to: tempURL))
        }
    }

    func rendered(_ pdf: Data) -> Result<Void, RenderError> {
        guard let path = state.path, let orgChart = state.orgChart else {
            preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that does not include a path and an OrgChart")
        }
        
        progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.facesCropped
        progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.orgChartRendered)
        defer {
            progress.resignCurrent()
        }
        
        let pdfPath = path.appendingPathComponent("\(orgChartName).pdf")
        do {
            try pdf.write(to: pdfPath, options: .atomic)
            self.state = .orgChartRendered(path: path, orgChart: orgChart, pdf: pdf)
            return .success(Void())
        } catch {
            return .failure(RenderError.couldNotWriteData(to: pdfPath))
        }
    }
}
