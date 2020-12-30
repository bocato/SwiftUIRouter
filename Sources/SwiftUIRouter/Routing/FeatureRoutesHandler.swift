import Foundation
import SwiftUI

public protocol FeatureRoutesHandler {
    var routes: [ViewRoute.Type] { get }

    func destination<Context: View>(
        forRoute route: ViewRoute,
        from context: Context
    ) -> Feature.Type
}

//struct ExampleFeatureRoutesHandler: FeatureRoutesHandler {
//    var routes: [ViewRoute.Type] {
//        [
//            ExampleViewRoute.self
//        ]
//    }
//
//    func destination<Context: View>(
//        forRoute route: ViewRoute,
//        from context: Context
//    ) -> Feature.Type {
//        let isValidRoute = routes.contains(where: { $0.self == type(of: route) })
//        guard isValidRoute else {
//            preconditionFailure()
//        }
//        return ExampleFeature.self
//    }
//}
