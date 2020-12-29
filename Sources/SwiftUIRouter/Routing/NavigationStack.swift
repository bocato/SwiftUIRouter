import Foundation

public final class NavigationStack {
    public internal(set) var stack: [AnyViewRoute] = []

    public func push<R: ViewRoute>(_ route: R) {
        guard !stack.contains(
                where: { type(of: $0).identifier == type(of: route).identifier }
        ) else { return }
        stack.append(route.eraseToAnyViewRoute())
    }

    @discardableResult
    public func pop<R: ViewRoute>() -> R? {
        let last = stack.popLast()?.erasedType
        return last as? R
    }

    public func current<R: ViewRoute>() -> R? {
        stack.last?.erasedType as? R
    }
}
