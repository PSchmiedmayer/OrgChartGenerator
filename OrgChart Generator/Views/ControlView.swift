//
//  ControlView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI

protocol ControlViewDelegate: AnyObject {
    func cropFaces()
    func render()
}

struct ControlView: View {
    @ObservedObject var generator: OrgChartGenerator
    var delegate: ControlViewDelegate? = nil
    
    var pathBinding: Binding<String> {
        Binding(
            get: {
                self.generator.state.path?.path ?? ""
            }, set: { newValue in
                guard let path = URL(string: newValue), path.isFileURL, path.hasDirectoryPath else {
                    return
                }
                
                self.generator.state = .pathProvided(path: path)
            }
        )
    }
    
    var body: some View {
        HStack {
            Text("OrgChartPath")
            TextField("Path", text: pathBinding)
            Spacer()
            Button(action: generateAction) {
                Text("Generate OrgChart")
            }
        }
    }
    
    func generateAction() {
        delegate?.cropFaces()
        delegate?.render()
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(generator: OrgChartGenerator())
    }
}
