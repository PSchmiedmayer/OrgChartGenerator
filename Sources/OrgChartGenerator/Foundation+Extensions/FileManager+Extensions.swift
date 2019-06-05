//
//  ImageCollection.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation

extension FileManager {
    
    func allFilePaths(forLocalPath path: URL) -> [URL] {
        guard let fileEnumerator = self.enumerator(at: path,
                                                   includingPropertiesForKeys: [.isDirectoryKey],
                                                   options: .skipsHiddenFiles,
                                                   errorHandler: nil) else {
            return []
        }
        
        return fileEnumerator.compactMap({
            if let filePath = $0 as? URL, !filePath.hasDirectoryPath {
                return filePath
            }
            return nil
        })
    }
}
