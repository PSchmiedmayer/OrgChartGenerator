//
//  FaceCrop.swift
//  OrgChartGenerator
//
//  Created by Paul Schmiedmayer on 6/4/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Cocoa
import OrgChart


public enum FaceCropError: Error {
    case couldNotReadData(from: URL)
    case couldNotWriteData(to: URL)
    
    public var localizedDescription: String {
        switch self {
        case let .couldNotReadData(url):
            return "Could not read data from (\(url)), the file was either moved or the tool has not sufficient access."
        case let .couldNotWriteData(url):
            return "Could not write data to (\(url))."
        }
    }
}

extension OrgChart {
    public func crop(withTempURL tempURL: URL?, imageSize: Int, compression: Double) throws {
        precondition(0.0...1.0 ~= compression)
        
        let cropImagesCount = self.teams.reduce(0, { $0 + $1.members.values.count })
            + self.crossTeamRoles.reduce(0, { $0 + $1.management.count })
        
        let progress = Progress(totalUnitCount: Int64(cropImagesCount))
        
        func transform(_ member: Member) throws -> Member {
            var imageTransformations: [ImageTransformationType] = []
            if member.cropImage {
                imageTransformations.append(.cropSquareCenteredOnFace)
            }
            imageTransformations.append(ImageTransformationType.scale(toSize: CGSize(width: imageSize, height: imageSize)))
            
            guard let image = ImageProcessor.process(imageFromPath: member.picture, withTransformations: imageTransformations) else {
                throw FaceCropError.couldNotReadData(from: member.picture)
            }
            
            let outputFileType: FileType = .jpeg
            member.picture = tempURL?.appendingPathComponent("\(UUID()).\(outputFileType)", isDirectory: false) ?? member.picture
            let imageData = image.imageData(as: outputFileType, withCompressionFactor: compression)
            try imageData.write(to: member.picture, options: .atomic)
            
            progress.completedUnitCount += 1
            return member
        }
        
        var transformedTeams: [Int: Result<Team, Error>] = [:]
        DispatchQueue.concurrentPerform(iterations: self.teams.count, execute: { index in
            do {
                let team = self.teams[index]
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
                self.teams[index] = team
            case let .failure(error):
                throw error
            }
        }

        var transformedCrossTeamRole: [Int: Result<CrossTeamRole, Error>] = [:]
        DispatchQueue.concurrentPerform(iterations: self.crossTeamRoles.count, execute: { index in
            do {
                let crossTeamRole = self.crossTeamRoles[index]
                crossTeamRole.management = try crossTeamRole.management.map(transform)
                transformedCrossTeamRole[index] = .success(crossTeamRole)
            } catch {
                transformedCrossTeamRole[index] = .failure(error)
            }
        })

        for (index, result) in transformedCrossTeamRole {
            switch result {
            case let .success(crossTeamRole):
                self.crossTeamRoles[index] = crossTeamRole
            case let .failure(error):
                throw error
            }
        }
    }
    
}
