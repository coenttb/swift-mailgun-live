//
//  File.swift
//  swift-mailgun-live
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Shared_Live
@_exported import Mailgun_Suppressions_Types
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Suppressions.Allowlist.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Suppressions.Allowlist.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest
        @Dependency(\.envVars.mailgun.domain) var domain

        return Self(
            get: { value in
                try await handleRequest(
                    for: makeRequest(.get(domain: domain, value: value)),
                    decodingTo: Mailgun.Suppressions.Allowlist.Record.self
                )
            },

            delete: { value in
                try await handleRequest(
                    for: makeRequest(.delete(domain: domain, value: value)),
                    decodingTo: Mailgun.Suppressions.Allowlist.Delete.Response.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Allowlist.List.Response.self
                )
            },

            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Allowlist.Create.Response.self
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteAll(domain: domain)),
                    decodingTo: Mailgun.Suppressions.Allowlist.Delete.All.Response.self
                )
            },

            importList: { request in
                try await handleRequest(
                    for: makeRequest(.importList(domain: domain, request: request)),
                    decodingTo: Mailgun.Suppressions.Allowlist.Import.Response.self
                )
            }
        )
    }
}

extension Mailgun.Suppressions.Allowlist {
    public typealias Authenticated = Mailgun_Shared_Live.Authenticated<
        Mailgun.Suppressions.Allowlist.API,
        Mailgun.Suppressions.Allowlist.API.Router,
        Mailgun.Suppressions.Allowlist.Client
    >
}

extension Mailgun.Suppressions.Allowlist: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Suppressions.Allowlist.Authenticated {
        try! Mailgun.Suppressions.Allowlist.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Suppressions.Allowlist.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Suppressions.Allowlist.API.Router = .init()
}
