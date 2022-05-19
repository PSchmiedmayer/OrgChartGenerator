//
//  ContentView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/19/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import Combine
import OrgChartRenderContext


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
        if case let .orgChartParsed(_, renderContext) = generator.state {
            return orgChartVisible(renderContext)
        }
        if case let .imagesLoaded(_, renderContext) = generator.state {
            return orgChartVisible(renderContext)
        }
        if case let .imagesCropped(_, renderContext) = generator.state {
            return orgChartVisible(renderContext)
        }
        if case let .orgChartRendered(_, renderContext, _) = generator.state {
            return orgChartVisible(renderContext)
        }
        return AnyView(
            Text("Unknown State")
        )
    }
    
    func onlyControlView(_ message: String) -> AnyView {
        AnyView(
            VStack {
                ControlView(renderPDF: generatePDFBinding)
                Text(message)
            }
        )
    }
    
    func orgChartVisible(_ renderContext: OrgChartRenderContext) -> AnyView {
        AnyView(
            VStack {
                ControlView(renderPDF: generatePDFBinding)
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    PDFExportView(view: OrgChartView(context: renderContext),
                                  renderAsPDF: generatePDFBinding) { pdf in
                        self.pdfCancellable = self.generator.rendered(pdf)
                            .sink(receiveCompletion: { _ in }, receiveValue: { })
                    }.preferredColorSchemeCompat(.light)
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
