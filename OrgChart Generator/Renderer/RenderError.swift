//
//  RenderError.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation


enum RenderError: Error {
    case couldNotWriteData(url: URL)
    
    var localizedDescription: String {
        switch self {
        case let .couldNotWriteData(url):
            return "Could not write data to (\(url))."
        }
    }
}
