//
//  ProgressIndicator.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/21/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: NSViewRepresentable {
    @Binding var loading: Bool
    

    func makeNSView(context: Context) -> NSProgressIndicator {
        let activityIndicator = NSProgressIndicator()
        activityIndicator.style = .spinning
        activityIndicator.isDisplayedWhenStopped = false
        activityIndicator.sizeToFit()
        return activityIndicator
    }

    func updateNSView(_ activityIndicator: NSProgressIndicator, context: Context) {
        if loading {
            activityIndicator.startAnimation(nil)
        } else {
            activityIndicator.stopAnimation(nil)
        }
    }
}
