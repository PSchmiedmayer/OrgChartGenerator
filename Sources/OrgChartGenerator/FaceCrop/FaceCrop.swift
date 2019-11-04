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
            let imageData = image.imageData(as: outputFileType, withCompressionFactor: compression)
            try imageData.write(to: member.picture, options: .atomic)
            
            progress.completedUnitCount += 1
            return member
        }
        
        var transformedTeams: [Int: Result<Team, Error>] = [:]
        DispatchQueue.concurrentPerform(iterations: orgChart.teams.count, execute: { index in
            do {
                let team = orgChart.teams[index]
                team.members = Dictionary(uniqueKeysWithValues: try team.members.map({ position, members in
                    return (position, try members.map(transform))
                }))
                transformedTeams[index] = .success(team)
            } catch {
                transformedTeams[index] = .failure(error)
            }
        })

        for (index, result) in transformedTeams {
            switch result {
            case let .success(team):
                orgChart.teams[index] = team
            case let .failure(error):
                throw error
            }
        }

        var transformedCrossTeamRole: [Int: Result<CrossTeamRole, Error>] = [:]
        DispatchQueue.concurrentPerform(iterations: orgChart.crossTeamRoles.count, execute: { index in
            do {
                let crossTeamRole = orgChart.crossTeamRoles[index]
                crossTeamRole.management = try crossTeamRole.management.map(transform)
                transformedCrossTeamRole[index] = .success(crossTeamRole)
            } catch {
                transformedCrossTeamRole[index] = .failure(error)
            }
        })

        for (index, result) in transformedCrossTeamRole {
            switch result {
            case let .success(crossTeamRole):
                orgChart.crossTeamRoles[index] = crossTeamRole
            case let .failure(error):
                throw error
            }
        }
    }
}
