//
//  File.swift
//  swift-mailgun-live
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Authenticating
import Dependencies
import DependenciesMacros
import Foundation
import Mailgun_AccountManagement_Live
import Mailgun_Credentials_Live
import Mailgun_CustomMessageLimit_Live
import Mailgun_Domains_Live
import Mailgun_IPAllowlist_Live
import Mailgun_IPPools_Live
import Mailgun_IPs_Live
import Mailgun_Keys_Live
import Mailgun_Lists_Live
import Mailgun_Messages_Live
import Mailgun_Reporting_Live
import Mailgun_Routes_Live
@_exported import Mailgun_Shared_Live
import Mailgun_Subaccounts_Live
import Mailgun_Suppressions_Live
import Mailgun_Templates_Live
@_exported import Mailgun_Types
import Mailgun_Users_Live
import Mailgun_Webhooks_Live

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

extension Mailgun.Client {
    public static func live() throws
        -> Mailgun_Shared_Live.Authenticated<Mailgun.API, Mailgun.API.Router, Mailgun.Client>
    {

        @Dependency(Mailgun.API.Router.self) var mailgunRouter
        @Dependency(\.envVars.mailgun.domain) var domain

        return try .init(
            router: mailgunRouter
        ) { makeRequest in
            .init(
                messages: .live {
                    try makeRequest(Mailgun.API.messages($0))
                },
                mailingLists: .live {
                    try makeRequest(Mailgun.API.lists($0))
                },
                events: .live {
                    try makeRequest(Mailgun.API.events($0))
                },
                suppressions: .live {
                    try makeRequest(Mailgun.API.suppressions($0))
                },
                webhooks: .live {
                    try makeRequest(Mailgun.API.webhooks($0))
                },
                domains: .live {
                    try makeRequest(Mailgun.API.domains($0))
                },
                templates: .live {
                    try makeRequest(Mailgun.API.templates($0))
                },
                routes: .live {
                    try makeRequest(Mailgun.API.routes($0))
                },
                ips: .live {
                    try makeRequest(Mailgun.API.ips($0))
                },
                ipPools: .live {
                    try makeRequest(Mailgun.API.ipPools($0))
                },
                ipAllowlist: .live {
                    try makeRequest(Mailgun.API.ipAllowlist($0))
                },
                keys: .live {
                    try makeRequest(Mailgun.API.keys($0))
                },
                users: .live {
                    try makeRequest(Mailgun.API.users($0))
                },
                subaccounts: .live {
                    try makeRequest(Mailgun.API.subaccounts($0))
                },
                credentials: .live {
                    try makeRequest(Mailgun.API.credentials($0))
                },
                customMessageLimit: .live {
                    try makeRequest(Mailgun.API.customMessageLimit($0))
                },
                accountManagement: .live {
                    try makeRequest(Mailgun.API.accountManagement($0))
                },
                reporting: .live {
                    try makeRequest(Mailgun.API.reporting($0))
                }
            )
        }
    }
}

extension Mailgun {
    public typealias Authenticated = Mailgun_Shared_Live.Authenticated<
        Mailgun.API, Mailgun.API.Router, Mailgun.Client
    >
}

extension Mailgun: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Authenticated {
        try! Mailgun.Client.live()
    }
}

extension Mailgun.API.Router: @retroactive DependencyKey {
    public static let liveValue: Mailgun.API.Router = .init()
}

extension DependencyValues {
    public var mailgun: Mailgun.Authenticated {
        get { self[Mailgun.self] }
        set { self[Mailgun.self] = newValue }
    }
}
