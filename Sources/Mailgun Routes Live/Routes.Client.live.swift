//
//  File.swift
//  swift-mailgun-live
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Routes_Types
@_exported import Mailgun_Shared_Live
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Routes.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Routes.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Mailgun.Routes.Create.Response.self
                )
            },
            list: { limit, skip in
                try await handleRequest(
                    for: makeRequest(.list(limit: limit, skip: skip)),
                    decodingTo: Mailgun.Routes.List.Response.self
                )
            },
            get: { routeId in
                try await handleRequest(
                    for: makeRequest(.get(id: routeId)),
                    decodingTo: Mailgun.Routes.Get.Response.self
                )
            },
            update: { routeId, request in
                try await handleRequest(
                    for: makeRequest(.update(id: routeId, request: request)),
                    decodingTo: Mailgun.Routes.Update.Response.self
                )
            },
            delete: { routeId in
                try await handleRequest(
                    for: makeRequest(.delete(id: routeId)),
                    decodingTo: Mailgun.Routes.Delete.Response.self
                )
            },
            match: { address in
                try await handleRequest(
                    for: makeRequest(.match(address: address)),
                    decodingTo: Mailgun.Routes.Match.Response.self
                )
            }
        )
    }
}

extension Mailgun.Routes {
    public typealias Authenticated = Mailgun_Shared_Live.Authenticated<
        Mailgun.Routes.API,
        Mailgun.Routes.API.Router,
        Mailgun.Routes.Client
    >
}

extension Mailgun.Routes: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Routes.Authenticated {
        try! Mailgun.Routes.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Routes.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Routes.API.Router = .init()
}
