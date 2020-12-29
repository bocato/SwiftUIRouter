import SwiftUI
import Combine

public protocol ViewRoute: Identifiable {
    static var identifier: String { get }
}
public extension ViewRoute {
    var id: String { Self.identifier }
    func eraseToAnyViewRoute() -> AnyViewRoute {
        AnyViewRoute(self)
    }
}

public struct AnyViewRoute: ViewRoute {
    public let metaType: Any
    init<T: ViewRoute>(_ routeType: T.Type) {
        metaType = routeType
    }
}

public final class NavigationStack {
    public internal(set) var stack: [ViewRoute] = []
    public var current: ViewRoute? { stack.last }

    public func push(_ route: ViewRoute) {
        guard !stack.contains(
                where: { type(of: $0).identifier == type(of: route).identifier }
        ) else { return }
        stack.append(route)
    }

    @discardableResult
    public func pop() -> ViewRoute? {
        let last = stack.popLast()
        return last
    }
}

public protocol ViewResolverInterface {
    func registerViewBuilder<V: View, Environment, Route: ViewRoute>(
        _ builder: (Environment, Route) -> V,
        forRouteType routeType: Route.Type
    )
    func viewFor<Environment>(
        _ route: ViewRoute,
        environment: Environment
    ) -> AnyView
}
//
//public final class ViewResolver

public final class SwiftUIRouter {
    // MARK: - Public Properties

    @Published public var presentedView: AnyView?

    // MARK: - Properties

    var cancelables: Set<AnyCancellable> = .init()
    private(set) var navigationStack: NavigationStack = .init()
    private var cachedViews: [AnyView] = [] // do i really need this?

    public init<Content: View>(@ViewBuilder initialViewBuilder: () -> Content? = { nil } ) {
        if let initialView = initialViewBuilder() {
            self.presentedView = AnyView(initialView)
        }
    }

    public func navigate(
        toRoute route: ViewRoute,
        style:
    )

}
