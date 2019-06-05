//
//  FaceCrop.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Cocoa

final class FaceCrop {
    static func crop(_ orgChart: OrgChart, tempURL: URL?, imageSize: Int, compression: Double) throws {
        precondition(0.0...1.0 ~= compression)
        
        let cropImagesCount = orgChart.teams.reduce(0, { $0 + $1.members.values.count })
            + orgChart.crossTeamRoles.reduce(0, { $0 + $1.management.count })
        
        let progress = Progress(totalUnitCount: Int64(cropImagesCount))
        
        func transform(_ member: Member) throws -> Member {
            var imageTransformations: [ImageTransformationType] = []
            if member.cropImage {
                imageTransformations.append(.cropSquareCenteredOnFace)
            }
            imageTransformations.append(ImageTransformationType.scale(toSize: CGSize(width: imageSize, height: imageSize)))
            
            guard let image = ImageProcessor.process(imageFromPath: member.picture, withTransformations: imageTransformations) else {
                throw GeneratorError.couldNotReadData(from: member.picture)
            }
            
            let outputFileType: FileType = .jpeg
            member.picture = tempURL?.appendingPathComponent("\(UUID()).\(outputFileType)", isDirectory: false) ?? member.picture
            try image.imageData(as: outputFileType, withCompressionFactor: compression).write(to: member.picture, options: .atomic)
            
            progress.completedUnitCount += 1
            return member
        }
        
        orgChart.teams = try orgChart.teams.map({ team in
            team.members = Dictionary(uniqueKeysWithValues: try team.members.map({ position, members in
                return (position, try members.map(transform))
            }))
            return team
        })
        
        orgChart.crossTeamRoles = try orgChart.crossTeamRoles.map({ crossTeamRole in
            crossTeamRole.management = try crossTeamRole.management.map(transform)
            return crossTeamRole
        })
    }
}
