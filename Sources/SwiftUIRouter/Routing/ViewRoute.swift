import Foundation

public protocol ViewRoute: Identifiable {
    static var identifier: String { get }
}
public extension ViewRoute {
    var id: String { Self.identifier }

    func eraseToAnyViewRoute() -> AnyViewRoute {
        .init(self)
    }
}

public struct AnyViewRoute: ViewRoute {
    public private(set) static var identifier: String = "invalid_route"
    public let erasedType: Any

    public init<T: ViewRoute>(_ erasedType: T) {
        self.erasedType = erasedType
        Self.identifier = T.identifier
    }

    public static func == (lhs: AnyViewRoute, rhs: AnyViewRoute) -> Bool {
        lhs.id == rhs.id
    }
}
