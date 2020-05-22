//
//  OrgChartGenerator.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart
import Combine

class OrgChartGeneratorSettings: ObservableObject {
    private enum Defaults {
        static let orgChartName: String = "OrgChart"
        static let imageSize: Int = 500
        static let compressionRate: Double = 0.6
        static let cropFaces: Bool = true
    }
    
    
    @Published var orgChartName: String
    @Published var imageSize: Int
    @Published var compressionRate: Double
    @Published var cropFaces: Bool
    
    
    init(orgChartName: String = Defaults.orgChartName,
        imageSize: Int = Defaults.imageSize,
        compressionRate: Double = Defaults.compressionRate,
        cropFaces: Bool = Defaults.cropFaces) {
        self.orgChartName = orgChartName
        self.imageSize = imageSize
        self.compressionRate = compressionRate
        self.cropFaces = cropFaces
    }
}


class OrgChartGenerator: ObservableObject {
    private enum Defaults {
        static let path: URL? = nil
    }
    
    
    @Published var state: OrgChartGeneratorState = .initialized
    @Published var fractionCompleted: Double = 0.0
    @Published var settings: OrgChartGeneratorSettings
    
    private var progress: Progress
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(path: URL? = Defaults.path, settings: OrgChartGeneratorSettings? = nil) {
        if let path = path {
            self.state = .pathProvided(path: path)
        }
        self.settings = settings ?? OrgChartGeneratorSettings()
        
        self.progress = Progress(totalUnitCount: 100)
        progress.publisher(for: \.fractionCompleted)
            .receive(on: RunLoop.main)
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
    
    
    @discardableResult
    func parseOrgChart() -> AnyPublisher<Void, OrgChartError> {
        Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let path = self.state.path else {
                    preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that does not include a path")
                }
                
                self.progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.pathProvided
                self.progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.orgChartParsed)
                defer {
                    self.progress.resignCurrent()
                }
                
                do {
                    let orgChart = try OrgChart(fromDirectory: path)
                    DispatchQueue.main.async {
                        self.state = .orgChartParsed(path: path, orgChart: orgChart)
                    }
                    promise(.success(Void()))
                } catch let error as OrgChartError {
                    promise(.failure(error))
                } catch {
                    promise(.failure(OrgChartError.couldNotReadData(from: path)))
                }
            }
        }.receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    @discardableResult
    func rendered(_ pdf: Data) -> AnyPublisher<Void, RenderError> {
        Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let path = self.state.path, let orgChart = self.state.orgChart else {
                    preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that does not include a path and an OrgChart")
                }
                
                self.progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.facesCropped
                self.progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.orgChartRendered)
                defer {
                    self.progress.resignCurrent()
                }
                
                let pdfPath = path.appendingPathComponent("\(self.settings.orgChartName).pdf")
                do {
                    try pdf.write(to: pdfPath, options: .atomic)
                    DispatchQueue.main.async {
                        self.state = .orgChartRendered(path: path, orgChart: orgChart, pdf: pdf)
                    }
                    promise(.success(Void()))
                } catch {
                    promise(.failure(RenderError.couldNotWriteData(to: pdfPath)))
                }
            }
        }.receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
