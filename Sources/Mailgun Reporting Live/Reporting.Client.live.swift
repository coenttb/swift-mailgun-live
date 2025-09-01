//
//  File.swift
//  swift-mailgun-live
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_Reporting_Types
@_exported import Mailgun_Shared_Live
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Reporting.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Mailgun.Reporting.API) throws -> URLRequest
    ) -> Self {
        return .init(
            metrics: .live {
                try makeRequest(.metrics($0))
            },
            stats: .live {
                try makeRequest(.stats($0))
            },
            events: .live {
                try makeRequest(.events($0))
            },
            tags: .live {
                try makeRequest(.tags($0))
            },
            logs: .live {
                try makeRequest(.logs($0))
            }
        )
    }
}

extension Mailgun.Reporting {
    public typealias Authenticated = Mailgun_Shared_Live.Authenticated<
        Mailgun.Reporting.API,
        Mailgun.Reporting.API.Router,
        Mailgun.Reporting.Client
    >
}

extension Mailgun.Reporting: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Reporting.Authenticated {
        try! Mailgun.Reporting.Authenticated { .live(makeRequest: $0) }
    }
}

extension Mailgun.Reporting.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.Reporting.API.Router = .init()
}
