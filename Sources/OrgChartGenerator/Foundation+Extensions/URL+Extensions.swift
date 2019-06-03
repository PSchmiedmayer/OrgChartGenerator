//
//  URL+Extensions.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 5/31/19.
//

import Foundation

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
    func extractInformation() -> (position: Position?, name: String, role: String?, color: Background?) {
        let lastPathComponent = self.deletingPathExtension().lastPathComponent
        var components = lastPathComponent.split(omittingEmptySubsequences: false, whereSeparator: { $0 == "_" })
        
        assert(components.count > 0 && components.count <= 4)
        
        // Extract the POSITION
        var position: Position? = nil
        do {
            if components.count > 1, let potentialPosition = components.first {
                position = try Position(potentialPosition)
                components.removeFirst()
            }
        } catch { }
        
        let name: String = components.first.flatMap(String.init) ?? lastPathComponent
        components.removeFirst()
        
        var background: Background? = nil
        do {
            background = try components.last.flatMap(Background.init(hexString:))
            if background != nil {
                components.removeLast()
            }
        } catch { }
        
        let role = components.last.flatMap(String.init)
        
        return (position, name, role, background)
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
