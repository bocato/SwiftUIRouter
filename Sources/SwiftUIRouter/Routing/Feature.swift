import Foundation
import SwiftUI

public protocol Feature {
    static func buildView<Environment>(
        fromRoute route: ViewRoute?,
        withEnvironment environment: Environment
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
//    static func buildView<Environment>(
//        fromRoute route: ViewRoute?,
//        withEnvironment environment: Environment
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
