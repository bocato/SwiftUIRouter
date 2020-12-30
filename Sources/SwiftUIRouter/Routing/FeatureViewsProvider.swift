import Foundation
import SwiftUI

public protocol FeatureDependenciesRegistrationProtocol {
    func register<T>(
        dependencyFactory: @escaping DependencyFactory,
        forType metaType: T.Type
    )

    func register(routesHandler: FeatureRoutesHandler)
}

public protocol FeatureViewsProviderProtocol {
    func hostingController<Environment>(
        withInitialFeature feature: Feature.Type,
        environment: Environment
    ) -> UIHostingController<AnyView>

    func viewForRoute<Environment, Context: View>(
       _ route: ViewRoute,
       from context: Context,
       environment: Environment
   ) -> AnyView
}
public extension FeatureViewsProviderProtocol {
    func viewForRoute<Environment>(
       _ route: ViewRoute,
       environment: Environment
    ) -> AnyView {
        self.viewForRoute(
            route,
            from: EmptyView(),
            environment: environment
        )
    }
}

public enum FeatureViewsProviderError: Error {
    case unregisteredRouteForIdentifier(String)
}

public final class FeatureViewsProvider: FeatureDependenciesRegistrationProtocol, FeatureViewsProviderProtocol {
    // MARK: - Dependencies

    let container: DependenciesContainerInterface
    let failureHandler: () -> Void

    // MARK: - Properties

    private(set) var registeredRoutes = [String: (AnyViewRouteType, FeatureRoutesHandler)]()

    // MARK: - Initialization

    public init(
        container: DependenciesContainerInterface? = nil,
        failureHandler: @escaping () -> Void = { preconditionFailure() }
    ) {
        self.container = container ?? DependenciesContainer()
        self.failureHandler = failureHandler
    }

    // MARK: - Public API

    public func register<T>(
        dependencyFactory: @escaping DependencyFactory,
        forType metaType: T.Type
    ) {
        container.register(
            factory: dependencyFactory,
            forMetaType: metaType
        )
    }

    public func register(routesHandler: FeatureRoutesHandler) {
        routesHandler.routes.forEach {
            registeredRoutes[$0.identifier] = ($0.asAnyViewRouteType, routesHandler)
        }
    }

    public func hostingController<Environment>(
        withInitialFeature feature: Feature.Type,
        environment: Environment
    ) -> UIHostingController<AnyView> {
        if let resolvableEnvironment = environment as? ResolvableEnvironment {
            resolvableEnvironment.resolve(withContainer: container)
        }
        let rootView = feature.buildView(
            fromRoute: nil,
            withEnvironment: environment
        )
        return UIHostingController(rootView: rootView)
    }

    public func viewForRoute<Environment, Context: View>(
        _ route: ViewRoute,
        from context: Context,
        environment: Environment
    ) -> AnyView {
        guard let handler = handler(forRoute: route) else {
            failureHandler()
            return AnyView(EmptyView()) // @TODO: Review this...
        }

        if let resolvableEnvironment = environment as? ResolvableEnvironment {
            resolvableEnvironment.resolve(withContainer: container)
        }

        let feature = handler.destination(
            forRoute: route,
            from: context
        )

        let newView = feature.buildView(
            fromRoute: route,
            withEnvironment: environment
        )

        return newView
    }

    func handler(forRoute route: ViewRoute) -> FeatureRoutesHandler? {
        let routeIdentifier = type(of: route).identifier
        return registeredRoutes[routeIdentifier]?.1
    }
}
