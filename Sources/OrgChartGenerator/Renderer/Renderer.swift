//
//  File.swift
//  
//
//  Created by Paul Schmiedmayer on 5/19/20.
//

import SwiftUI
import AppKit

enum Renderer {
    static let renderNotification = Notification(name: Notification.Name("OrgChartRendererNotification"))
    
    static func render<V: View>(_ view: V, withSize size: CGSize) -> Data {
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(origin: .zero, size: size)
        
        _ = view.drawingGroup()
        let data = hostingView.dataWithPDF(inside: hostingView.frame)
        NotificationCenter.default.post(renderNotification)
        hostingView.setNeedsDisplay(hostingView.frame)
        return hostingView.dataWithPDF(inside: hostingView.frame)
    }
}
