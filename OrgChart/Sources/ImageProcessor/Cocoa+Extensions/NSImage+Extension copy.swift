//
//  NSImage+Extension.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import AppKit

extension NSImage {
    var ciImage: CIImage? {
        guard let tiffRepresentation = self.tiffRepresentation,
            let bitmapImageRep = NSBitmapImageRep(data: tiffRepresentation),
            let ciImage = CIImage(bitmapImageRep: bitmapImageRep) else {
            return nil
        }
        return ciImage
    }
    
    /// Scales the image to a specific size
    /// - Parameter size: The size the image should be scaled to
    /// - Returns: The image that has been scaled
    public func scale(toSize size: CGSize) -> NSImage {
        transform(partOfImage: CGRect(origin: .zero, size: self.representations.first?.size ?? self.size),
                  intoRect: CGRect(origin: .zero, size: size))
    }
    
    /// Crops the image to a specific size
    /// - Parameter rect: The size the image should be cropped to
    /// - Returns: Returns the cropped image
    public func crop(to rect: CGRect) -> NSImage {
        transform(partOfImage: rect,
                  intoRect: rect)
    }
    
    /// Compresses the image by a specific compression factor
    /// - Parameters:
    ///   - compressionFactor: The compression factor that should be applied
    ///   - useHEIF: Inficates if HEIF compression should be applied
    /// - Returns: Returns the compressed image as a `Data` representation
    public func compress(compressionFactor: CGFloat, useHEIF: Bool = false) -> Data? {
        if useHEIF {
            guard let ciImage = ciImage else {
                return nil
            }
            
            let context = CIContext(options: nil)
            // swiftlint:disable:next force_cast line_length
            let options = NSDictionary(dictionary: [kCGImageDestinationLossyCompressionQuality: compressionFactor]) as! [CIImageRepresentationOption: Any]

            // swiftlint:disable:next force_unwrapping
            let colorSpace = ciImage.colorSpace!
            return context.heifRepresentation(of: ciImage,
                                              format: CIFormat.ARGB8,
                                              colorSpace: colorSpace,
                                              options: options)
        } else {
            guard let tiff = self.tiffRepresentation, let imageRep = NSBitmapImageRep(data: tiff) else {
                return nil
            }
            return imageRep.representation(using: .jpeg, properties: [.compressionFactor: compressionFactor])
        }
    }
    
    /// Compresses the image by a specific compression factor
    /// - Parameters:
    ///   - compressionFactor: The compression factor that should be applied
    ///   - useHEIF: Inficates if HEIF compression should be applied
    /// - Returns: Returns the compressed image
    public func compress(compressionFactor: CGFloat, useHEIF: Bool = false) -> NSImage? {
        guard let compressedData: Data = compress(compressionFactor: compressionFactor, useHEIF: useHEIF) else {
            return nil
        }
        let image = NSImage(data: compressedData)
        if image == nil {
            print("IMAGE IS NIL")
        }
        return image
    }
    
    /// Compresses the image under a specified megabyte threshold
    /// - Parameters:
    ///   - megabytes: The megabyte threshold
    /// - Returns: Returns the compressed image
    public func compress(underMegabytes megabytes: CGFloat) -> NSImage? {
        var compressionFactor: CGFloat = 1.0
        var compressedData: Data?
        while CGFloat(compressedData?.count ?? Int.max) > megabytes * 1024 * 1024 && compressionFactor > 0.4 {
            compressedData = self.compress(compressionFactor: compressionFactor)
            compressionFactor -= 0.1
        }
        
        guard let data = compressedData else {
            return nil
        }
        
        return NSImage(data: data)
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
        
        guard let imageRepresentation = self.representations.first else {
            return self
        }
        imageRepresentation.draw(in: NSRect(origin: .zero, size: targetRect.size),
                                 from: partOfImage,
                                 operation: .copy,
                                 fraction: 1.0,
                                 respectFlipped: true,
                                 hints: nil)
        
        let croppedImage = NSImage(size: targetRect.size)
        croppedImage.addRepresentation(bitmapRep)
        return croppedImage
    }
}
