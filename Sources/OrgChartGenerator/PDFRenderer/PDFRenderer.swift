//
//  PDFRenderer.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//

import Foundation
import WebKit

final class PDFRenderer: NSObject, WebFrameLoadDelegate {
    private static let webView = WebView()
    private static let webFrameHandler = WebFrameHandler()
    
    private final class WebFrameHandler: NSObject, WebFrameLoadDelegate {
        var callback: ((WebView, WebFrame) -> ())? = nil
        
        func webView(_ sender: WebView, didFinishLoadFor frame: WebFrame!) {
            if sender.stringByEvaluatingJavaScript(from: "document.readyState") == "complete" {
                sender.frameLoadDelegate = nil
                callback?(sender, frame)
                callback = nil
            }
        }
    }
    
    static func render(html: String, baseURL url: URL, completion: ((OrgChartError?) -> ())?) {
        webView.frameLoadDelegate = webFrameHandler
        webFrameHandler.callback = { webView, frame in
            let printOpts: [NSPrintInfo.AttributeKey : Any] = [
                NSPrintInfo.AttributeKey.jobDisposition: NSPrintInfo.JobDisposition.save,
                NSPrintInfo.AttributeKey.jobSavingURL: url.appendingPathComponent("\(Generator.Constants.orgChartName).pdf", isDirectory: false)
            ]
            
            let printInfo: NSPrintInfo = NSPrintInfo(dictionary: printOpts)
            printInfo.paperSize = frame.frameView.documentView.frame.size.applying(.init(scaleX: 0.8, y: 0.8))
            printInfo.bottomMargin = 0.0
            printInfo.topMargin = 0.0
            printInfo.leftMargin = 0.0
            printInfo.rightMargin = 0.0
            printInfo.isVerticallyCentered = true
            printInfo.isHorizontallyCentered = true
            
            let printOp: NSPrintOperation = NSPrintOperation(view: webView.mainFrame.frameView.documentView, printInfo: printInfo)
            
            printOp.showsPrintPanel = false
            printOp.showsProgressPanel = false
            printOp.run()
        }
        webView.mainFrame.loadHTMLString(html, baseURL: url)
    }
}
