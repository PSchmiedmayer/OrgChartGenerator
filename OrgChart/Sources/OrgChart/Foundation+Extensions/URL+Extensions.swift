//
//  URL+Extensions.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation

struct Information {
    let position: Position?
    let name: String
    let role: String?
    let color: Background?
    let cropImage: Bool
}

extension URL {
    /**
     Extracts the position, name and role from the `URL`.
     
     The naming syntax of the file or directory is the following:
     
     ```[POSITION_]NAME[_ROLE][.FILE_EXTENSION]```
     - POSITION: [A valid Position's String representation](x-source-tag://Position) will be ignored.
     - NAME: The `name` return value of the function.
     - ROLE: The `role` return value of the function.
     - FILE_EXTENSION: An optional file extension that is going to be ignored.
     
     Examples of valid file or directory names at the end of the `fileURL` `URL` are:
     - `01_Paul Schmiedmayer_CEO.png`
     - `Paul Schmiedmayer.jpg`
     - `Paul Schmiedmayer`
     - `99_Paul Schmiedmayer.png`
     
     - Returns:
     - position: The name of the entity extracted from the URL as described by the logic in the discussion section.
     - name: The name of the entity extracted from the URL as described by the logic in the discussion section.
     - role: The role of the entity extracted from the URL as described by the logic in the discussion section.
     */
    func extractInformation() throws -> Information {
        let lastPathComponent = self.deletingPathExtension().lastPathComponent
        
        var imageComponents = lastPathComponent.split(omittingEmptySubsequences: false, whereSeparator: { $0 == "^" })
        guard imageComponents.count > 0 && imageComponents.count <= 2 else {
            throw OrgChartError.impossibleToExtractInformation("Unexpected number of components \(imageComponents.count) when splitting \(self.lastPathComponent) to extract the image components.")
        }
        
        var cropImage = true
        if imageComponents.count == 2 {
            if imageComponents.last?.lowercased() == "nocrop" {
                cropImage = false
            }
            imageComponents.removeLast()
        }
        
        var informationComponents = imageComponents.first!.split(omittingEmptySubsequences: false, whereSeparator: { $0 == "_" })
        guard informationComponents.count > 0 && informationComponents.count <= 4 else {
            throw OrgChartError.impossibleToExtractInformation("Unexpected number of components \(imageComponents.count) when splitting \(self.lastPathComponent) to extract the information components.")
        }
        
        // Extract the POSITION
        var position: Position? = nil
        do {
            if informationComponents.count > 1, let potentialPosition = informationComponents.first {
                position = try Position(potentialPosition)
                informationComponents.removeFirst()
            }
        } catch { }
        
        let name: String = informationComponents.first.flatMap(String.init) ?? lastPathComponent
        informationComponents.removeFirst()
        
        var color: Background? = nil
        do {
            color = try informationComponents.last.flatMap(Background.init(hexString:))
            if color != nil {
                informationComponents.removeLast()
            }
        } catch { }
        
        let role = informationComponents.last.flatMap(String.init)
        
        return Information(position: position, name: name, role: role, color: color, cropImage: cropImage)
    }
    
    func content() throws -> [URL] {
        guard let directoryEnumerator = FileManager.default.enumerator(at: self,
                                                                       includingPropertiesForKeys: [.isDirectoryKey],
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]) else {
            throw OrgChartError.notADirectory(self)
        }
        
        return directoryEnumerator.compactMap({ $0 as? URL }).sorted(by: { $0.absoluteString < $1.absoluteString })
    }
}
