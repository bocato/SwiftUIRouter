//import SwiftUI
//
//public protocol ViewFactoryInterface {
//    func registerViewBuilder<Environment, Route: ViewRoute, CustomView: View>(
//        _ builder: @escaping (Environment, Route) -> CustomView,
//        forRouteType routeType: Route.Type
//    )
//
//    func viewFor<Route: ViewRoute, Environment>(
//        _ route: Route,
//        environment: Environment
//    ) -> AnyView
//}
//
//public final class ViewFactory: ViewFactoryInterface {
//    var builders: [String: AnyViewBuilder] = [:]
//
//    public func registerViewBuilder<Environment, Route: ViewRoute, CustomView: View>(
//        _ builder: @escaping (Environment, Route) -> CustomView,
//        forRouteType routeType: Route.Type
//    ) {
//        let key = routeType.identifier
//        builders[key] = AnyViewBuilder(builder)
//    }
//
//    public func viewFor<Route: ViewRoute, Environment>(
//        _ route: Route,
//        environment: Environment
//    ) -> AnyView {
//        let key = type(of: route).identifier
//        let typeErasedViewRoute = route.eraseToAnyViewRoute()
//        let typeErasedEnvironment = AnyEnvironment(environment)
//        guard let builder = builders[key] else {
//            return AnyView(EmptyView()) // TODO: Review this, use a failure handler...
//        }
//        return builder.erasedBuilder(typeErasedEnvironment, typeErasedViewRoute)
//    }
//}
//extension ViewFactory {
//    struct AnyViewBuilder {
//        let erasedBuilder: (AnyEnvironment, AnyViewRoute) -> AnyView
//        init<V: View, Environment, Route: ViewRoute>(
//            _ builder: @escaping (Environment, Route) -> V
//        ) {
//            erasedBuilder = { typeErasedEnvironment, typeErasedViewRoute in
//                guard
//                    let environment = typeErasedEnvironment.erasedType as? Environment,
//                    let route = typeErasedViewRoute.erasedType as? Route
//                else {
//                    preconditionFailure("This should never happen!") // TODO: Review this...
//                }
//                let view = builder(environment, route)
//                return AnyView(view)
//            }
//        }
//    }
//
//    struct AnyEnvironment {
//        let erasedType: Any
//        init(_ erasedType: Any) {
//            self.erasedType = erasedType
//        }
//    }
//}
