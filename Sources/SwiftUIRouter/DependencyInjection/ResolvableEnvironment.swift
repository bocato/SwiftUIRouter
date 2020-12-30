import Foundation

public protocol ResolvableEnvironment: Resolvable {}
extension ResolvableEnvironment {
    func initialize(withContainer container: DependenciesContainerInterface) {
        let mirror = Mirror(reflecting: self)
        mirror.children.forEach { child in
            if let resolvableChild = child as? Resolvable {
                resolvableChild.resolve(withContainer: container)
            }
        }
    }
}
