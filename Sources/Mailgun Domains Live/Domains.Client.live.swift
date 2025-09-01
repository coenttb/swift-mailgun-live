//
//  File.swift
//  swift-mailgun-live
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Domains_Types
@_exported import Mailgun_Shared_Live
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Domains.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Domains.API) throws -> URLRequest
    ) -> Self {
        .init(
            domains: .live { route in
                try makeRequest(.domain(route))
            },
            dkimSecurity: .live { route in
                try makeRequest(.dkimSecurity(route))
            },
            domainKeys: .live { route in
                try makeRequest(.dkimKeys(route))
            },
            domainTracking: .live { route in
                try makeRequest(.dkimTracking(route))
            }
        )
    }
}

extension Mailgun.Domains {
    public typealias Authenticated = Mailgun_Shared_Live.Authenticated<
        Mailgun.Domains.API,
        Mailgun.Domains.API.Router,
        Mailgun.Domains.Client
    >
}

extension Mailgun.Domains: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Domains.Authenticated {
        try! Mailgun.Domains.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Domains.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Domains.API.Router = .init()
}
