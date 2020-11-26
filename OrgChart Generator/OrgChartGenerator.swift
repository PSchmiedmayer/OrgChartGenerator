//
//  OrgChartGenerator.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import OrgChart
import OrgChartRenderContext
import Combine


class OrgChartGenerator: ObservableObject {
    @Published var state: OrgChartGeneratorState = .initialized
    @Published var loading: Bool = false
    @Published var fractionCompleted: Double = 0.0
    @Published var settings: OrgChartGeneratorSettings
    @Published var generatePDF: Bool = false
    
    private var progress: Progress
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(path: URL? = nil, settings: OrgChartGeneratorSettings = OrgChartGeneratorSettings()) {
        self.settings = settings
        
        self.progress = Progress(totalUnitCount: 100)
        progress.publisher(for: \.fractionCompleted)
            .receive(on: RunLoop.main)
            .sink { fractionCompleted in
                self.fractionCompleted = fractionCompleted
            }
            .store(in: &cancellables)
        
        if let path = path ?? settings.path {
            DispatchQueue.main.async {
                self.readOrgChart(from: path)
                    .flatMap { _ -> AnyPublisher<Void, OrgChartError> in
                        if settings.autogenerate == true {
                            return self.autogenerate(from: path)
                                .eraseToAnyPublisher()
                        } else {
                            return Just(Void())
                                .setFailureType(to: OrgChartError.self)
                                .eraseToAnyPublisher()
                        }
                    }
                    .sink(receiveCompletion: { completion in
                            switch completion {
                            case let .failure(error):
                                print("Could not generate the orgChart: \(error)")
                            case .finished: break
                            }
                        }, receiveValue: { })
                    .store(in: &self.cancellables)
            }
        } else if settings.autogenerate == true {
            exit(1)
        }
        
        $state
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    func autogenerate(from path: URL) -> AnyPublisher<Void, OrgChartError> {
        self.parseOrgChart()
            .setFailureType(to: OrgChartError.self)
            .flatMap {
                self.loadImages()
                    .setFailureType(to: OrgChartError.self)
            }
            .flatMap {
                self.cropImages()
                    .setFailureType(to: OrgChartError.self)
            }
            .map {
                self.generatePDF = true
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
    @discardableResult
    func readOrgChart(from path: URL) -> AnyPublisher<Void, OrgChartError> {
        Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.sync {
                    self.loading = true
                }
                self.progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.pathProvided
                self.progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.pathProvided)
                defer {
                    self.progress.resignCurrent()
                }
                
                do {
                    let orgChart = try OrgChart(fromDirectory: path)
                    DispatchQueue.main.sync {
                        self.state = .pathProvided(path: path, orgChart: orgChart)
                    }
                    promise(.success(Void()))
                } catch let error as OrgChartError {
                    print(error)
                    promise(.failure(error))
                } catch {
                    print("Could not read data from \(path)")
                    promise(.failure(OrgChartError.couldNotReadData(from: path)))
                }
            }
        }.receive(on: RunLoop.main)
            .map {
                self.loading = false
            }
            .mapError { (error: OrgChartError) in
                if self.settings.autogenerate == true {
                    exit(1)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func parseOrgChart() -> AnyPublisher<Void, Never> {
        Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let path = self.state.path else {
                    preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that does not include a path and an OrgChart")
                }
                
                guard case let .pathProvided(_, orgChart) = self.state else {
                    return
                }
                
                DispatchQueue.main.sync {
                    self.loading = true
                }
                self.progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.orgChartParsed
                self.progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.orgChartParsed)
                defer {
                    self.progress.resignCurrent()
                }
                
                let renderContext = OrgChartRenderContext(orgChart)
                DispatchQueue.main.sync {
                    self.state = .orgChartParsed(path: path, renderContext: renderContext)
                }
                promise(.success(Void()))
            }
        }.receive(on: RunLoop.main)
            .map {
                self.loading = false
            }
            .eraseToAnyPublisher()
    }

    @discardableResult
    func loadImages() -> AnyPublisher<Void, Never> {
        Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let path = self.state.path, let renderContext = self.state.renderContext else {
                    preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that doesn't include a path and a render context")
                }
                
                DispatchQueue.main.sync {
                    self.loading = true
                }
                self.progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.imagesLoaded
                self.progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.imagesLoaded)
                defer {
                    self.progress.resignCurrent()
                }
                
                renderContext.loadImages()
                DispatchQueue.main.sync {
                    self.state = .imagesLoaded(path: path, renderContext: renderContext)
                }
                promise(.success(Void()))
            }
        }.receive(on: RunLoop.main)
            .map {
                self.loading = false
            }
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func cropImages() -> AnyPublisher<Void, Never> {
        Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let path = self.state.path, let renderContext = self.state.renderContext else {
                    preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that doesn't include a path and a render context")
                }
                
                DispatchQueue.main.sync {
                    self.loading = true
                }
                self.progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.imagesCropped
                self.progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.imagesCropped)
                defer {
                    self.progress.resignCurrent()
                }
                
                renderContext.cropImages(cropFaces: self.settings.cropFaces,
                                         size: CGSize(width: self.settings.imageSize, height: self.settings.imageSize),
                                         compressionFactor: self.settings.compressionFactor)
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: {
                        self.state = .imagesCropped(path: path, renderContext: renderContext)
                        promise(.success(Void()))
                    })
                    .store(in: &self.cancellables)
            }
        }.receive(on: RunLoop.main)
            .map {
                self.loading = false
            }
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func rendered(_ pdf: Data) -> AnyPublisher<Void, RenderError> {
        Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let path = self.state.path, let renderContext = self.state.renderContext else {
                    preconditionFailure("Could not parse the OrgChart from a OrgChartGeneratorState that does not include a path and an OrgChart")
                }
                
                DispatchQueue.main.sync {
                    self.loading = true
                }
                self.progress.completedUnitCount = OrgChartGeneratorState.ProcessCompletedUnitCount.orgChartRendered
                self.progress.becomeCurrent(withPendingUnitCount: OrgChartGeneratorState.ProcessFraction.orgChartRendered)
                defer {
                    self.progress.resignCurrent()
                }
                
                let pdfPath = path.appendingPathComponent("\(self.settings.orgChartName).pdf")
                do {
                    try pdf.write(to: pdfPath, options: .atomic)
                    DispatchQueue.main.sync {
                        self.state = .orgChartRendered(path: path, renderContext: renderContext, pdf: pdf)
                    }
                    promise(.success(Void()))
                } catch {
                    promise(.failure(RenderError.couldNotWriteData(url: pdfPath)))
                }
            }
        }.receive(on: RunLoop.main)
            .map {
                self.loading = false
            }
            .map {
                if self.settings.autogenerate {
                    exit(0)
                }
            }
            .eraseToAnyPublisher()
    }
}
