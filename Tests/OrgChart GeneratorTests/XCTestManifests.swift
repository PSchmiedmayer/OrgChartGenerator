import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OrgChart_GeneratorTests.allTests),
    ]
}
#endif
