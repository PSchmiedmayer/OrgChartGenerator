//
//  ContentView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/19/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var generator = OrgChartGenerator()
    @State var renderAsPDF: Bool = false
    
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
        return AnyView(
            VStack {
                ControlView(renderPDF: $renderAsPDF)
                Text(message)
            }
        )
    }
    
    func orgChartVisible(_ renderContext: OrgChartRenderContext) -> AnyView {
        AnyView(
            VStack {
                ControlView(renderPDF: $renderAsPDF)
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    PDFExportView(view: OrgChartView(context: renderContext),
                                  renderAsPDF: $renderAsPDF) { pdf in
                        self.generator.rendered(pdf)
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
