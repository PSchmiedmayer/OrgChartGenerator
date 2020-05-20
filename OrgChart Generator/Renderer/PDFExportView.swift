//
//  Renderer.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import AppKit

struct PDFExportView<PrintableView: View>: NSViewRepresentable {
    let view: PrintableView
    @Binding var renderAsPDF: Bool
    let onPDFRender: (Data) -> ()
    
    func makeNSView(context: Context) -> NSView {
        let printWrapperView = NSHostingView(rootView: view)
        renderAsPDF(printWrapperView)
        return printWrapperView
    }
    
    func updateNSView(_ printWrapperView: NSView, context: Context) {
        renderAsPDF(printWrapperView)
    }
    
    private func renderAsPDF(_ view: NSView) {
        if renderAsPDF {
            DispatchQueue.main.async {
                self.renderAsPDF = false
                self.onPDFRender(view.dataWithPDF(inside: view.frame))
            }
        }
    }
}
