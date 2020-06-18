//
//  ImageLoadable.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/23/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import Combine


protocol ImageHandler: ImageLoadable & ImageCropable { }


protocol ImageLoadable {
    mutating func loadImages()
}


protocol ImageCropable {
    mutating func cropImages(cropFaces: Bool, size: CGSize, compressionFactor: CGFloat) -> AnyPublisher<Void, Never>
}
