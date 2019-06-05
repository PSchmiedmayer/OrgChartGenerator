//
//  Background.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import AppKit

struct Background {
    static let white = Background(.white)
    
    let color: NSColor
    
    private init(_ color: NSColor) {
        self.color = color
    }
    
    init <S: StringProtocol>(hexString: S) throws {
        let hexString = hexString.trimmingCharacters(in: CharacterSet(charactersIn: "#").union(.whitespacesAndNewlines))
        guard let color = UInt32(hexString, radix: 16), hexString.count == 6 || hexString.count == 8 else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [],
                                                                    debugDescription: "Non expected hex string: \(hexString)"))
        }
        
        func colorSegment(shift: Int8) -> CGFloat {
            return CGFloat(Int(color >> shift) & 0xFF) / 255.0
        }
        
        self.color = NSColor(red: colorSegment(shift: hexString.count == 6 ? 16 : 24),
                             green: colorSegment(shift: hexString.count == 6 ? 8 : 16),
                             blue: colorSegment(shift: hexString.count == 6 ? 0 : 8),
                             alpha: colorSegment(shift: hexString.count == 6 ? -8 : 0))
    }
    
    var hexString: String {
        guard let rgbColor = color.usingColorSpaceName(.calibratedRGB) else {
            return "#FFFFFF"
        }
        
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}

extension Background: CustomStringConvertible {
    var description: String {
        return hexString
    }
}

extension Background: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(hexString: try container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hexString)
    }
}
