import Combine
import Foundation
import SwiftUI

protocol Route {
    static var identifier: String { get }
}

open class Navigation {
    private(set) var stack: [Route] = []
    var current: Route? { stack.last }

    func push(_ route: Route) {
        guard !stack.contains(
                where: { type(of: $0).identifier == type(of: route).identifier }
        ) else { return }
        stack.append(route)
    }

    @discardableResult
    func pop() -> Route? {
        let last = stack.popLast()
        return last
    }
}

typealias ViewBuilder = (Route) -> AnyView

protocol ViewsFactoryProtocol {
    func register<R: Route>(_ arg: @escaping ViewBuilder, forRoute route: R.Type)
}

final class ViewsFactory {

    private var viewInstances = NSMapTable<NSString, AnyObject>(
        keyOptions: .strongMemory,
        valueOptions: .weakMemory
    )

    private(set) var viewBuilders: [String: ViewBuilder] = [:]

    func register<R: Route>(_ arg: @escaping ViewBuilder, forRoute route: R.Type) {
        let name = R.identifier
        viewBuilders[name] = arg
    }

    func resolveView(for route: Route, store: DependencyStoreProtocol) -> AnyView {
        let name = type(of: route).identifier
        let builder = viewBuilders[name]! // review this
        let view = builder(route)
        return view
    }
}

final class Router: ObservableObject {
    // Dependencies
    private var navigation: Navigation
    private let dependencyStore: DependencyStoreProtocol
    private let viewsFactory:

    // Properties
    var previousRoute: Route?
    @Published var rootView: AnyView!

    init(
        navigation: Navigation = .init(),
        dependencyStore: DependencyStoreProtocol = DependencyStore()
    ) {
        self.navigation = navigation
        self.dependencyStore = dependencyStore
    }

    func push(_ route: Route) {
        navigation.push(route)

    }

    func pop() {

    }
}

