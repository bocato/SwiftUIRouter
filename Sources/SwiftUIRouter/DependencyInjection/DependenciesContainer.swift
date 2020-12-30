import Foundation

/// Defines a factory that builds a dependency
public typealias DependencyFactory = () -> Any

/// Defines a contract for a dependency container
public protocol DependenciesContainerInterface: AnyObject {
    /// Get's a dependency from the container
    /// - Parameter arg: the type of the dependency
    func get<T>(_ arg: T.Type) -> T?

    /// Registers a dependency for the given type
    /// - Parameters:
    ///   - factory: a dependency factory
    ///   - metaType: the dependency metatype
    ///   - failureHandler: a handler to tells us that the dependency registration failed for some reason
    func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type,
        failureHandler: (String) -> Void
    )
    #if DEBUG
    /// Enables uns to swap a factory for a given metatype, if needed.
    /// - Parameters:
    ///   - metaType: the dependency metatype
    ///   - newFactory: a new dependency factory
    func swapFactory<T>(forMetaType metaType: T.Type, to newFactory: @escaping DependencyFactory)
    #endif
}
public extension DependenciesContainerInterface {
    /// Registers a dependency for the given type
    /// - Parameters:
    ///   - factory: a dependency factory
    ///   - metaType: the dependency metatype
    func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type
    ) {
        register(
            factory: factory,
            forMetaType: metaType,
            failureHandler: { preconditionFailure($0) }
        )
    }
}

/// The concrete implementation of a dependency store
public final class DependenciesContainer: DependenciesContainerInterface {
    // MARK: - Properties

    var dependencyInstances = NSMapTable<NSString, AnyStorableDependency>(
        keyOptions: .strongMemory,
        valueOptions: .weakMemory
    )

    var dependencyFactories = [String: DependencyFactory]()

    // MARK: - Initialization

    public init() {}

    // MARK: - Public API

    public func get<T>(_ arg: T.Type) -> T? {
        let name = String(describing: arg)
        let object = dependencyInstances.object(forKey: name as NSString)

        guard object == nil else {
            return object?.instance as? T
        }

        guard let factory: DependencyFactory = dependencyFactories[name] else {
            return nil
        }

        let newInstance = factory()
        let wrappedInstance = AnyStorableDependency(instance: newInstance)
        dependencyInstances.setObject(wrappedInstance, forKey: name as NSString)
        return newInstance as? T
    }

    public func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type,
        failureHandler: (String) -> Void
    ) {
        let name = String(describing: metaType)
        guard dependencyFactories[name] == nil else {
            failureHandler("A dependency should never be registered twice!")
            return
        }
        dependencyFactories[name] = factory
    }

    #if DEBUG
    public func swapFactory<T>(forMetaType metaType: T.Type, to newFactory: @escaping DependencyFactory) {
        let name = String(describing: metaType)
        dependencyFactories[name] = newFactory
    }
    #endif
}
extension DependenciesContainer {
    // MARK: - Inner Types

    final class AnyStorableDependency {
        let instance: Any
        init(instance: Any) {
            self.instance = instance
        }
    }
}
