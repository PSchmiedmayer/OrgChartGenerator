//
//  ContentView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/19/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import Combine


struct ContentView: View {
    @ObservedObject var generator = OrgChartGenerator()
    @State var pdfCancellable: AnyCancellable?
    
    
    var generatePDFBinding: Binding<Bool> {
        Binding(get: {
            self.generator.generatePDF
        }) { newGeneratePDF in
            self.generator.generatePDF = newGeneratePDF
        }
    }
    
    var unsafeRenderContextBinding: Binding<OrgChartRenderContext> {
        Binding(get: {
            self.generator.state.renderContext!
        }) { newRenderContext in
            self.generator.state = OrgChartGeneratorState.set(renderContext: newRenderContext,
                                                              on: self.generator.state)
        }
    }
    
    var body: some View {
        chooseMainView()
            .environmentObject(generator)
    }
    
    
    func chooseMainView() -> AnyView {
        if case .initialized = generator.state {
            return onlyControlView("Please provide a path to the OrgChart")
        }
        if case let .pathProvided(path, orgChart) = generator.state {
            return onlyControlView("Loading the OrgChart \"\(orgChart.title)\" found at \(path)")
        }
        if case .orgChartParsed = generator.state {
            return orgChartVisible(unsafeRenderContextBinding)
        }
        if case .imagesLoaded = generator.state {
            return orgChartVisible(unsafeRenderContextBinding)
        }
        if case .imagesCropped = generator.state {
            return orgChartVisible(unsafeRenderContextBinding)
        }
        if case .orgChartRendered = generator.state {
            return orgChartVisible(unsafeRenderContextBinding)
        }
        return AnyView(
            Text("Unknown State")
        )
    }
    
    func onlyControlView(_ message: String) -> AnyView {
        return AnyView(
            VStack {
                ControlView(renderPDF: generatePDFBinding)
                Text(message)
            }
        )
    }
    
    func orgChartVisible(_ renderContext: Binding<OrgChartRenderContext>) -> AnyView {
        AnyView(
            VStack {
                ControlView(renderPDF: generatePDFBinding)
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    PDFExportView(view: OrgChartView(context: renderContext),
                                  renderAsPDF: generatePDFBinding) { pdf in
                        self.pdfCancellable = self.generator.rendered(pdf)
                            .sink(receiveCompletion: { _ in }, receiveValue: { })
                    }
                }
            }
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
