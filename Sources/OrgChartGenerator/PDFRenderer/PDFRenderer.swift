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
        var callback: ((WebView) -> ())? = nil
        
        func webView(_ sender: WebView, didFinishLoadFor frame: WebFrame!) {
            if sender.stringByEvaluatingJavaScript(from: "document.readyState") == "complete" {
                sender.frameLoadDelegate = nil
                callback?(sender)
                callback = nil
            }
        }
    }
    
    static func render(html: String, baseURL url: URL, completion: ((OrgChartError?) -> ())?) {
        webView.frameLoadDelegate = webFrameHandler
        webFrameHandler.callback = { webView in
            guard let height = Double(webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")),
                  let width = Double(webView.stringByEvaluatingJavaScript(from: "document.body.scrollWidth")) else {
                return
            }
            
            let printOpts: [NSPrintInfo.AttributeKey : Any] = [
                NSPrintInfo.AttributeKey.jobDisposition: NSPrintInfo.JobDisposition.save,
                NSPrintInfo.AttributeKey.jobSavingURL: url.appendingPathComponent("\(Generator.Constants.orgChartName).pdf", isDirectory: false)
            ]
            
            let printInfo: NSPrintInfo = NSPrintInfo(dictionary: printOpts)
            printInfo.paperSize = CGSize(width: width, height: height)
            
            let printOp: NSPrintOperation = NSPrintOperation(view: webView.mainFrame.frameView.documentView, printInfo: printInfo)
            
            printOp.showsPrintPanel = false
            printOp.showsProgressPanel = false
            printOp.run()
        }
        webView.mainFrame.loadHTMLString(html, baseURL: url)
    }
}
