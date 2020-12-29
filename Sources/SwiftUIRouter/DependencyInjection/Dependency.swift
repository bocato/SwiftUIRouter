import Foundation

/// Defines an interface for instances that can be resolved from a container
public protocol Resolvable {
    /// Resolves an instance using a container.
    /// - Parameter container: the dependencies container that stores that instance
    func resolve(withContainer container: DependenciesContainerInterface)
}

/// Defines a failure handler for a dependency resolver, which returns the failure reason as a String
public typealias DependencyResolverFailureHandler = (String) -> Void

/// Defines a resolvable dependency, which is able to resolve itself using a store.
@propertyWrapper
public final class Dependency<T>: Resolvable {
    // MARK: - Dependencies

    private var container: DependenciesContainerInterface
    private let failureHandler: DependencyResolverFailureHandler

    // MARK: - Properties

    private(set) var resolvedValue: T!
    public var wrappedValue: T {
        if resolvedValue == nil {
            resolve(withContainer: container)
        }
        return resolvedValue
    }

    // MARK: - Initialization

    required init(
        resolvedValue: T?,
        container: DependenciesContainerInterface = DependenciesContainer.shared,
        failureHandler: @escaping DependencyResolverFailureHandler = { msg in preconditionFailure(msg) }
    ) {
        self.resolvedValue = resolvedValue
        self.container = container
        self.failureHandler = failureHandler
    }

    public convenience init() {
        self.init(resolvedValue: nil)
    }

    public static func resolvedValue(_ resolvedValue: T) -> Self {
        .init(resolvedValue: resolvedValue)
    }

    // MARK: - Public API

    public func resolve(withContainer container: DependenciesContainerInterface) {
        guard resolvedValue == nil else {
            failureHandler("Attempted to resolve \(type(of: self)) twice!")
            return
        }
        guard let value = container.get(T.self) else {
            failureHandler("Attempted to resolve \(type(of: self)), but there's nothing registered for this type.")
            return
        }
        resolvedValue = value
    }
}

// @TODO: Decide if this is even going to be used...
public protocol ResolvableEnvironment {}
public extension ResolvableEnvironment {
    static func initialize(container: DependenciesContainerInterface?) {
        Self.dependenciesContainerInstance = container ?? DependenciesContainer.shared
        Self.autoResolve()
    }

    private static func autoResolve() {
        let mirror = Mirror(reflecting: self)
        mirror.children.forEach { child in
            if let resolvableChild = child as? Resolvable {
                let container = Self.dependenciesContainer
                resolvableChild.resolve(withContainer: container)
            }
        }
    }
}

extension ResolvableEnvironment {
    public static var dependenciesContainer: DependenciesContainerInterface {
        get { dependenciesContainerInstance ?? DependenciesContainer.shared }
        set { dependenciesContainerInstance = newValue }
    }
    private static var dependenciesContainerInstance: DependenciesContainerInterface? {
        get {
            let objcAssociatedObject = objc_getAssociatedObject(
                self,
                &ResolvableEnvironmentAssociatedKeys.dependenciesContainerReference
            )
            return objcAssociatedObject as? DependenciesContainerInterface
        }
        set {
            objc_setAssociatedObject(
                self,
                &ResolvableEnvironmentAssociatedKeys.dependenciesContainerReference,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

enum ResolvableEnvironmentAssociatedKeys {
    static var dependenciesContainerReference = "DependenciesContainerReference"
}
