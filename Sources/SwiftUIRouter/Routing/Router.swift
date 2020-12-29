import SwiftUI
import Combine

public protocol ViewFactoryInterface {
    func registerViewBuilder<Environment, Route: ViewRoute, CustomView: View>(
        _ builder: @escaping (Environment, Route) -> CustomView,
        forRouteType routeType: Route.Type
    )

    func viewFor<Route: ViewRoute, Environment>(
        _ route: Route,
        environment: Environment
    ) -> AnyView
}

public final class ViewFactory: ViewFactoryInterface {

    var builders: [String: AnyViewBuilder] = [:]

    public func registerViewBuilder<Environment, Route: ViewRoute, CustomView: View>(
        _ builder: @escaping (Environment, Route) -> CustomView,
        forRouteType routeType: Route.Type
    ) {
        let key = routeType.identifier
        builders[key] = AnyViewBuilder(builder)
    }

    public func viewFor<Route: ViewRoute, Environment>(
        _ route: Route,
        environment: Environment
    ) -> AnyView {
        let key = type(of: route).identifier
        let typeErasedViewRoute = route.eraseToAnyViewRoute()
        let typeErasedEnvironment = AnyEnvironment(environment)
        return builders[key]!.erasedBuilder(typeErasedEnvironment, typeErasedViewRoute)
    }
}
extension ViewFactory {
    struct AnyViewBuilder {
        let erasedBuilder: (AnyEnvironment, AnyViewRoute) -> AnyView
        init<V: View, Environment, Route: ViewRoute>(
            _ builder: @escaping (Environment, Route) -> V
        ) {
            erasedBuilder = { environment, route in
                let e = environment.erasedType as! Environment
                let r = route.eraseToAnyViewRoute() as! Route
                let v = AnyView(builder(e, r))
                return v
            }
        }
    }

    struct AnyEnvironment {
        let erasedType: Any
        init(_ erasedType: Any) {
            self.erasedType = erasedType
        }
    }
}


//public final class SwiftUIRouter {
//    // MARK: - Public Properties
//
//    @Published public var presentedView: AnyView?
//
//    // MARK: - Properties
//
//    var cancelables: Set<AnyCancellable> = .init()
//    private(set) var navigationStack: NavigationStack = .init()
//    private var cachedViews: [AnyView] = []
//
//    public init<Content: View>(@ViewBuilder initialViewBuilder: () -> Content? = { nil } ) {
//        if let initialView = initialViewBuilder() {
//            self.presentedView = AnyView(initialView)
//        }
//    }
//
//    public func navigate(
//        toRoute route: ViewRoute,
//        style:
//    )
//
//}
