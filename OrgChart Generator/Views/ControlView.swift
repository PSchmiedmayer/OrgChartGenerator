//
//  ControlView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct ControlView: View {
    @ObservedObject var generator: OrgChartGenerator
    @State var cropFaces: Bool = false
    @Binding var renderPDF: Bool
    
    
    var pathBinding: Binding<String> {
        Binding(
            get: {
                self.generator.state.path?.path ?? ""
            }, set: { newValue in
                let path = URL(fileURLWithPath: newValue)
                guard path.isFileURL, path.hasDirectoryPath else {
                    return
                }
                
                self.generator.state = .pathProvided(path: path)
            }
        )
    }
    
    var disableGenerateButton: Bool {
        if case .initialized = generator.state {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack {
            Button(action: selectDirectory) {
                Text("Select the OrgChart Path")
            }
            Toggle(isOn: $cropFaces) {
                Text("Crop Faces")
            }
            Spacer()
            Button(action: generateAction) {
                Text("Generate OrgChart")
            }.disabled(disableGenerateButton)
        }
    }
    
    func selectDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        
        DispatchQueue.main.async {
            let result = panel.runModal()
            if result == .OK {
                guard let path = panel.url, path.isFileURL, path.hasDirectoryPath else {
                    return
                }
                
                self.generator.state = .pathProvided(path: path)
            }
        }
    }
    
    func generateAction() {
        generator.parseOrgChart()
        if cropFaces {
            generator.cropFaces()
        }
        renderPDF = true
    }
}

struct ControlView_Previews: PreviewProvider {
    @State static var renderPDF: Bool = false
    
    static var previews: some View {
        ControlView(generator: OrgChartGenerator(), renderPDF: $renderPDF)
    }
}
