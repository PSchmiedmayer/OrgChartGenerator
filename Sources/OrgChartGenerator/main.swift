import Utility
import Logging
import Foundation

var log = PrintLogger()

private let parser = ArgumentParser(usage: "-p <path>",
                                    overview: "🗂 OrgChart Generator - Generate an OrgChart from the given directory structure.")

// <options>
private let pathOption = parser.add(option: "--path",
                                    shortName: "-p",
                                    kind: String.self,
                                    usage: "The root folder of the directory structure that should be used to generate the OrgChart",
                                    completion: .filename)
private let versionOption = parser.add(option: "--version",
                                       shortName: "-v",
                                       kind: String.self,
                                       usage: "The version of the OrgChart, can e.g. be printed on the OrgChart",
                                       completion: nil)

// The first argument specifies the path of the executable file
private let arguments = Array(CommandLine.arguments.dropFirst()) // Drop first and convert to Array<String>
do {
    let result = try parser.parse(arguments) // Parse arguments
    guard let path = result.get(pathOption) else {
        throw ArgumentParserError.expectedValue(option: "--path")
    }
    
    let version = result.get(versionOption) ?? ""
    
    Generator.generateOrgChart(in: path, version: version) { error in
        defer {
            exit(0)
        }
        
        if let error = error {
            if let orgChartError = error as? OrgChartError {
                log.error(orgChartError.localizedDescription)
            } else {
                log.error("\(error)")
            }
            return
        }
        
        print("🗂 Generated the OrgChart")
    }
    
    RunLoop.main.run()
} catch let error as ArgumentParserError {
    print(error.description)
} catch let error {
    print(error.localizedDescription)
}
