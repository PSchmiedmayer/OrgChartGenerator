//
//  File.swift
//  
//
//  Created by Paul Schmiedmayer on 5/19/20.
//

import SwiftUI
import AppKit

enum Renderer {
    static func render<V: View>(_ view: V, withSize size: CGSize) -> Data {
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(origin: .zero, size: size)
        return hostingView.dataWithPDF(inside: hostingView.frame)
    }
}
