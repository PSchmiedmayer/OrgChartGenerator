//
//  NSImage+Extension.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Cocoa

extension NSImage {
    var ciImage: CIImage? {
        guard let tiffRepresentation = self.tiffRepresentation,
            let bitmapImageRep = NSBitmapImageRep(data: tiffRepresentation),
            let ciImage = CIImage(bitmapImageRep: bitmapImageRep) else {
            return nil
        }
        return ciImage
    }
    
    func imageData(as fileType: FileType, withCompressionFactor factor: Double = 1.0) -> Data {
        let bitmapImageRep = representations.first as! NSBitmapImageRep
        
        let factor = max(0.0, min(factor, 1.0))
        let properties = [NSBitmapImageRep.PropertyKey.compressionFactor : factor]
        
        return bitmapImageRep.representation(using: fileType, properties: properties)!
    }
    
    func scale(toSize size: CGSize) -> NSImage {
        return transform(partOfImage: CGRect(origin: .zero, size: self.size),
                         intoRect: CGRect(origin: .zero, size: size))
    }
    
    func crop(_ rect: CGRect) -> NSImage {
        return transform(partOfImage: rect,
                         intoRect: rect)
    }
    
    private func transform(partOfImage: CGRect, intoRect targetRect: CGRect) -> NSImage {
        guard let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                               pixelsWide: Int(targetRect.size.width),
                                               pixelsHigh: Int(targetRect.size.height),
                                               bitsPerSample: 8,
                                               samplesPerPixel: 4,
                                               hasAlpha: true,
                                               isPlanar: false,
                                               colorSpaceName: NSColorSpaceName.calibratedRGB,
                                               bytesPerRow: 0,
                                               bitsPerPixel: 0) else {
            return self
        }
        
        bitmapRep.size = targetRect.size
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
        self.draw(in: NSRect(origin: .zero, size: targetRect.size),
                  from: partOfImage,
                  operation: .copy,
                  fraction: 1.0)
        
        let croppedImage = NSImage(size: targetRect.size)
        croppedImage.addRepresentation(bitmapRep)
        return croppedImage
    }
}
