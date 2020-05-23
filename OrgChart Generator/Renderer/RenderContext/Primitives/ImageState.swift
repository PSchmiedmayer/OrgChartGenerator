//
//  ImageState.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/23/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import AppKit


enum ImageState: Hashable {
    case notLoaded(URL)
    case cloudNotBeLoaded
    case loaded(NSImage)
    case cropped(NSImage)
}
