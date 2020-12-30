import Foundation

public protocol ViewRoute {
    static var identifier: String { get }
}
public extension ViewRoute {
    static var asAnyViewRouteType: AnyViewRouteType {
        .init(self)
    }
}

public final class AnyViewRouteType {
    public let metatype: Any
    public init<T: ViewRoute>(_ routeType: T.Type) {
        self.metatype = routeType
    }
}
