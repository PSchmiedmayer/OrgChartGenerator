//
//  NSBitmapImageRep.FileType+Extension.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Cocoa

typealias FileType = NSBitmapImageRep.FileType

extension FileType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .tiff: return "tiff"
        case .bmp: return "bmp"
        case .gif: return "gif"
        case .jpeg: return"jpeg"
        case .png: return "png"
        case .jpeg2000: return "jpeg2000"
        @unknown default: return ""
        }
    }
    
    init?(_ string: String) {
        let fileType = string.lowercased()
        switch fileType {
        case FileType.tiff.description:
            self = .tiff
        case FileType.bmp.description:
            self = .bmp
        case FileType.gif.description:
            self = .gif
        case FileType.jpeg.description:
            self = .jpeg
        case FileType.png.description:
            self = .png
        case FileType.jpeg2000.description:
            self = .jpeg2000
        default:
            return nil
        }
    }
}
