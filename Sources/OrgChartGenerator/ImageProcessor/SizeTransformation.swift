//
//  SizeTransformation.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Cocoa

class SizeTransformation {
    static func createProcess(forSize size: CGSize) -> ((NSImage, (NSImage) -> ()) -> ()) {
        func process(image: NSImage, completion: (NSImage) -> ()) {
            autoreleasepool{
                completion(image.scale(toSize: size))
            }
        }
        
        return process
    }
}
