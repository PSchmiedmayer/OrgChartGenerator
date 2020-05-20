//
//  Renderer.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import AppKit

enum Renderer {
    static let renderNotification = Notification(name: Notification.Name("OrgChartRendererNotification"))

    static func render<V: View>(_ view: V, withSize size: CGSize) -> Data {
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(origin: .zero, size: size)
        return hostingView.dataWithPDF(inside: hostingView.frame)
    }
}
