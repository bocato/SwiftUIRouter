import SwiftUI
import Combine

public protocol Feature {
    func buildView<Route: ViewRoute, Environment>(
        fromRoute route: Route?,
        withEnvironment environment: Environment?
    ) -> AnyView
}

//struct ExampleViewRoute: ViewRoute {
//    static var identifier: String { "example:example_view" }
//}
//
//struct ExampleEnvironment {
//    let coisa: String
//}
//
//struct ExampleFeature: Feature {
//    func buildView<Route: ViewRoute, Environment>(
//        fromRoute route: Route?,
//        withEnvironment environment: Environment?
//    ) -> AnyView {
//        switch (route, environment) {
//        case let (route as ExampleViewRoute, environment as ExampleEnvironment):
//            debugPrint(route)
//            debugPrint(environment)
//            return AnyView(EmptyView())
//        default:
//            fatalError()
//        }
//    }
//}

public final class SwiftUIRouter {
    // MARK: - Public Properties

    @Published public var currentView: AnyView?
    @Published public var currentView: AnyView?

    // MARK: - Properties

    var cancelables: Set<AnyCancellable> = .init()
    private(set) var navigationStack: NavigationStack = .init()
    private var cachedViews: [AnyView] = []

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
