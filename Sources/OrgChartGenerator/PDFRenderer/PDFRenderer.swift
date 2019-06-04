//
//  PDFRenderer.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//

import Foundation
import WebKit

class PDFRenderer: NSObject, WebFrameLoadDelegate {
    private static let webView = WKWebView()
    private static var webViewDelegate: WebViewDelegate?
    
    private final class WebViewDelegate: NSObject, WKNavigationDelegate {
        private var completion: (Data) -> ()
        
        init(_ webView: WKWebView, completion: @escaping (Data) -> ()) {
            self.completion = completion
            
            super.init()
            
            webView.navigationDelegate = self
        }
        
        deinit {
            print("Removed!")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        webView.evaluateJavaScript("document.body.scrollWidth", completionHandler: { (width, error) in
                            let height = height as! CGFloat
                            let width = width as! CGFloat
                            webView.frame.size = CGSize(width: width, height: height)
                            webView.takeSnapshot(with: nil, completionHandler: { image, _ in
                                self.completion(image!.pngData!)
                            })
                        })
                    })
                }
                
            })
        }
    }
    
    static func renderHTMLOrgChart(foundInURL url: URL, completion: ((OrgChartError?) -> ())?) {
        webViewDelegate = WebViewDelegate(webView) { data in
            let pngURL = url.appendingPathComponent("\(Generator.Constants.orgChartName).png", isDirectory: false)
            do {
                try data.write(to: pngURL, options: .atomic)
                completion?(nil)
            } catch {
                completion?(OrgChartError.couldNotWriteData(to: pngURL))
            }
        }
        
        webView.loadFileURL(url.appendingPathComponent("\(Generator.Constants.orgChartName).html", isDirectory: false),
                            allowingReadAccessTo: url)
    }
}

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
}
