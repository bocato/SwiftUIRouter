import Foundation

/// Enable it's conformant to be able to register dependency factories
public protocol DependencyRegistering {}
public extension DependencyRegistering {
    /// Registers a factory to the `shared` container
    /// - Parameters:
    ///   - factory: a dependency factory
    ///   - metaType: the metatype to be build by the factory
    func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type
    ) {
        register(
            factory: factory,
            forMetaType: metaType,
            onContainer: DependenciesContainer.shared
        )
    }

    /// Registers a factory to a given container
    /// - Parameters:
    ///   - factory: a dependency factory
    ///   - metaType: the metatype to be build by the factory
    ///   - container: the dependency container to register the factories
    func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type,
        onContainer container: DependenciesContainerInterface
    ) {
        container.register(
            factory: factory,
            forMetaType: metaType
        )
    }
}
