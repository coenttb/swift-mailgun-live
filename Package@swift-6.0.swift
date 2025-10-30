// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let mailgun: Self = "Mailgun".live
    static let accountManagement: Self = "Mailgun AccountManagement".live
    static let credentials: Self = "Mailgun Credentials".live
    static let customMessageLimit: Self = "Mailgun CustomMessageLimit".live
    static let domains: Self = "Mailgun Domains".live
    static let ipAllowlist: Self = "Mailgun IPAllowlist".live
    static let ipPools: Self = "Mailgun IPPools".live
    static let ips: Self = "Mailgun IPs".live
    static let keys: Self = "Mailgun Keys".live
    static let lists: Self = "Mailgun Lists".live
    static let messages: Self = "Mailgun Messages".live
    static let reporting: Self = "Mailgun Reporting".live
    static let routes: Self = "Mailgun Routes".live
    static let subaccounts: Self = "Mailgun Subaccounts".live
    static let suppressions: Self = "Mailgun Suppressions".live
    static let templates: Self = "Mailgun Templates".live
    static let users: Self = "Mailgun Users".live
    static let webhooks: Self = "Mailgun Webhooks".live
    static let shared: Self = "Mailgun Shared".live
}

extension Target.Dependency {
    static var mailgun: Self { .target(name: .mailgun) }
    static var accountManagement: Self { .target(name: .accountManagement) }
    static var credentials: Self { .target(name: .credentials) }
    static var customMessageLimit: Self { .target(name: .customMessageLimit) }
    static var domains: Self { .target(name: .domains) }
    static var ipAllowlist: Self { .target(name: .ipAllowlist) }
    static var ipPools: Self { .target(name: .ipPools) }
    static var ips: Self { .target(name: .ips) }
    static var keys: Self { .target(name: .keys) }
    static var lists: Self { .target(name: .lists) }
    static var messages: Self { .target(name: .messages) }
    static var reporting: Self { .target(name: .reporting) }
    static var routes: Self { .target(name: .routes) }
    static var subaccounts: Self { .target(name: .subaccounts) }
    static var suppressions: Self { .target(name: .suppressions) }
    static var templates: Self { .target(name: .templates) }
    static var users: Self { .target(name: .users) }
    static var webhooks: Self { .target(name: .webhooks) }
    static var shared: Self { .target(name: .shared) }
}

extension Target.Dependency {
    static var authenticating: Self { .product(name: "Authenticating", package: "swift-authenticating") }
    static var environmentVariables: Self { .product(name: "EnvironmentVariables", package: "swift-environment-variables") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }
}

extension Target.Dependency {
    static var mailgunTypes: Self { .product(name: "Mailgun Types", package: "swift-mailgun-types" ) }
    static var accountManagementTypes: Self { .product(name: "Mailgun AccountManagement Types", package: "swift-mailgun-types" ) }
    static var credentialsTypes: Self { .product(name: "Mailgun Credentials Types", package: "swift-mailgun-types" ) }
    static var customMessageLimitTypes: Self { .product(name: "Mailgun CustomMessageLimit Types", package: "swift-mailgun-types" ) }
    static var domainsTypes: Self { .product(name: "Mailgun Domains Types", package: "swift-mailgun-types" ) }
    static var eventsTypes: Self { .product(name: "Mailgun Reporting Types", package: "swift-mailgun-types" ) }
    static var ipAllowlistTypes: Self { .product(name: "Mailgun IPAllowlist Types", package: "swift-mailgun-types" ) }
    static var ipPoolsTypes: Self { .product(name: "Mailgun IPPools Types", package: "swift-mailgun-types" ) }
    static var ipsTypes: Self { .product(name: "Mailgun IPs Types", package: "swift-mailgun-types" ) }
    static var keysTypes: Self { .product(name: "Mailgun Keys Types", package: "swift-mailgun-types" ) }
    static var listsTypes: Self { .product(name: "Mailgun Lists Types", package: "swift-mailgun-types" ) }
    static var messagesTypes: Self { .product(name: "Mailgun Messages Types", package: "swift-mailgun-types" ) }
    static var reportingTypes: Self { .product(name: "Mailgun Reporting Types", package: "swift-mailgun-types" ) }
    static var routesTypes: Self { .product(name: "Mailgun Routes Types", package: "swift-mailgun-types" ) }
    static var subaccountsTypes: Self { .product(name: "Mailgun Subaccounts Types", package: "swift-mailgun-types" ) }
    static var suppressionsTypes: Self { .product(name: "Mailgun Suppressions Types", package: "swift-mailgun-types" ) }
    static var tagsTypes: Self { .product(name: "Mailgun Reporting Types", package: "swift-mailgun-types" ) }
    static var templatesTypes: Self { .product(name: "Mailgun Templates Types", package: "swift-mailgun-types" ) }
    static var usersTypes: Self { .product(name: "Mailgun Users Types", package: "swift-mailgun-types" ) }
    static var webhooksTypes: Self { .product(name: "Mailgun Webhooks Types", package: "swift-mailgun-types" ) }
    static var mailgunTypesShared: Self { .product(name: "Mailgun Types Shared", package: "swift-mailgun-types" ) }
    static var urlrequestHandler: Self { .product(name: "URLRequestHandler", package: "swift-urlrequest-handler" ) }
    static var urlRouting: Self { .product(name: "URLRouting", package: "swift-url-routing" ) }
    static var urlFormCoding: Self { .product(name: "URLFormCoding", package: "swift-url-form-coding" ) }
}

let package = Package(
    name: "swift-mailgun-live",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: .mailgun, targets: [.mailgun]),
        .library(name: .accountManagement, targets: [.accountManagement]),
        .library(name: .credentials, targets: [.credentials]),
        .library(name: .customMessageLimit, targets: [.customMessageLimit]),
        .library(name: .domains, targets: [.domains]),
        .library(name: .ipAllowlist, targets: [.ipAllowlist]),
        .library(name: .ipPools, targets: [.ipPools]),
        .library(name: .ips, targets: [.ips]),
        .library(name: .keys, targets: [.keys]),
        .library(name: .lists, targets: [.lists]),
        .library(name: .messages, targets: [.messages]),
        .library(name: .reporting, targets: [.reporting]),
        .library(name: .routes, targets: [.routes]),
        .library(name: .subaccounts, targets: [.subaccounts]),
        .library(name: .suppressions, targets: [.suppressions]),
        .library(name: .templates, targets: [.templates]),
        .library(name: .users, targets: [.users]),
        .library(name: .webhooks, targets: [.webhooks]),
        .library(name: .shared, targets: [.shared])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-authenticating", from: "0.0.2"),
        .package(url: "https://github.com/coenttb/swift-environment-variables", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-urlrequest-handler", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-mailgun-types", from: "0.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.2"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.4.3"),
        .package(url: "https://github.com/coenttb/swift-url-form-coding", from: "0.1.0")
    ],
    targets: [
        .target(
            name: .shared,
            dependencies: [
                .issueReporting,
                .authenticating,
                .mailgunTypesShared,
                .environmentVariables,
                .urlRouting,
                .urlFormCoding,
                .urlrequestHandler

            ]
        ),
        .target(
            name: .mailgun,
            dependencies: [
                .shared,
                .mailgunTypesShared,
                .mailgunTypes,
                .issueReporting,
                .accountManagement,
                .credentials,
                .customMessageLimit,
                .domains,
                .ipAllowlist,
                .ipPools,
                .ips,
                .keys,
                .lists,
                .messages,
                .reporting,
                .routes,
                .subaccounts,
                .suppressions,
                .templates,
                .users,
                .webhooks
            ]
        ),
        .testTarget(
            name: .mailgun.tests,
            dependencies: [
                .mailgun,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .accountManagement,
            dependencies: [
                .shared,
                .mailgunTypesShared,
                .accountManagementTypes,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .accountManagement.tests,
            dependencies: [.accountManagement, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .credentials,
            dependencies: [
                .shared,
                .mailgunTypesShared,
                .credentialsTypes,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .credentials.tests,
            dependencies: [.credentials, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .customMessageLimit,
            dependencies: [
                .shared,
                .mailgunTypesShared,
                .customMessageLimitTypes,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .customMessageLimit.tests,
            dependencies: [.customMessageLimit, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .domains,
            dependencies: [
                .shared,
                .mailgunTypesShared,
                .domainsTypes,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .domains.tests,
            dependencies: [.domains, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ipAllowlist,
            dependencies: [
                .shared,
                .mailgunTypesShared,
                .ipAllowlistTypes,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .ipAllowlist.tests,
            dependencies: [.ipAllowlist, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ipPools,
            dependencies: [
                .ipPoolsTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .ipPools.tests,
            dependencies: [.ipPools, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ips,
            dependencies: [
                .ipsTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .ips.tests,
            dependencies: [.ips, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .keys,
            dependencies: [
                .keysTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .keys.tests,
            dependencies: [.keys, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .lists,
            dependencies: [
                .listsTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .lists.tests,
            dependencies: [.lists, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .messages,
            dependencies: [
                .messagesTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .messages.tests,
            dependencies: [.messages, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .reporting,
            dependencies: [
                .reportingTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .reporting.tests,
            dependencies: [.reporting, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .routes,
            dependencies: [
                .routesTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .routes.tests,
            dependencies: [.routes, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .subaccounts,
            dependencies: [
                .subaccountsTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .subaccounts.tests,
            dependencies: [.subaccounts, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .suppressions,
            dependencies: [
                .suppressionsTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .suppressions.tests,
            dependencies: [.suppressions, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .templates,
            dependencies: [
                .templatesTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .templates.tests,
            dependencies: [.templates, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .users,
            dependencies: [
                .usersTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .users.tests,
            dependencies: [.users, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .webhooks,
            dependencies: [
                .webhooksTypes,
                .shared,
                .mailgunTypesShared,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .webhooks.tests,
            dependencies: [.webhooks, .shared, .dependenciesTestSupport]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var live: Self { self + " Live" }
    var types: Self { self + " Types" }
}
