//
//  ContentView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/19/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart

struct ContentView: View {
    @ObservedObject var generator = OrgChartGenerator()
    @State var renderAsPDF: Bool = false
    
    var body: some View {
        if case .initialized = generator.state {
            return onlyControlView("Please provide a path to the OrgChart")
        }
        if case let .pathProvided(path) = generator.state {
            return onlyControlView("Press Parse to parse the OrgChart found at \(path)")
        }
        if case let .orgChartParsed(_, orgChart) = generator.state {
            return orgChartVisible(orgChart)
        }
        if case let .facesCropped(_, orgChart) = generator.state {
            return orgChartVisible(orgChart)
        }
        if case let .orgChartRendered(_, orgChart, _) = generator.state {
            return orgChartVisible(orgChart)
        }
        return AnyView(
            Text("Unknown State")
        )
    }
    
    func onlyControlView(_ message: String) -> AnyView {
        return AnyView(
            VStack {
                ControlView(generator: generator, renderPDF: $renderAsPDF)
                Text(message)
            }
        )
    }
    
    func orgChartVisible(_ orgChart: OrgChart) -> AnyView {
        AnyView(
            VStack {
                ControlView(generator: generator, renderPDF: $renderAsPDF)
                ScrollView {
                    PDFExportView(view: OrgChartView(orgChart: orgChart), renderAsPDF: $renderAsPDF) { pdf in
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
