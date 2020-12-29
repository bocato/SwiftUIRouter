import Foundation
@testable import SwiftUIRouter
import XCTest

final class DependencyRegisteringTests: XCTestCase {
    // MARK: - Tests

    func test_register_shouldAddTheFactoryToAContainer() {
        // Given
        let sut = DependencyRegisteringSubject()

        let container = DependenciesContainer()

        let instance = DummyDependency()
        let metaType = DummyDependencyProtocol.self
        let metaTypeKey = String(describing: metaType)

        // When
        sut.register(
            factory: { instance },
            forMetaType: metaType,
            onContainer: container
        )

        // Then
        let theContainerContainsTheFactory = container.dependencyFactories.contains(where: { $0.key == metaTypeKey })
        XCTAssertTrue(theContainerContainsTheFactory)
    }
}

// MARK: - Test Doubles

private struct DependencyRegisteringSubject: DependencyRegistering {}
