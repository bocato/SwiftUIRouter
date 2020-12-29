import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DependenciesContainerTests.allTests),
        testCase(DependencyRegisteringTests.allTests),
        testCase(DependencyTests.allTests),
    ]
}
#endif
