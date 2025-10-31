# swift-mailgun-live

[![CI](https://github.com/coenttb/swift-mailgun-live/workflows/CI/badge.svg)](https://github.com/coenttb/swift-mailgun-live/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Live implementation layer for swift-mailgun-types providing URLSession-based networking with complete API coverage.

## Overview

**swift-mailgun-live** provides production-ready implementations for the types and interfaces defined in [swift-mailgun-types](https://github.com/coenttb/swift-mailgun-types). This package transforms type-safe contracts into a fully functional Mailgun SDK with URLSession-based networking, authentication, and dependency injection.

> **Note:** For most users, we recommend using [swift-mailgun](https://github.com/coenttb/swift-mailgun) which provides a complete package including this implementation along with additional integrations.

## Features

### Production Ready
- URLSession-based networking with robust error handling
- Basic Authentication via swift-authenticating
- Environment configuration via swift-environment-variables
- Dependency injection via swift-dependencies
- Swift 6 language mode with complete concurrency support

### Complete API Coverage

All Mailgun API features are implemented with comprehensive test coverage:

- **Messages**: Send emails with attachments, templates, and recipient variables
- **Domains**: Domain management, DKIM, connection settings, tracking
- **Suppressions**: Bounces, complaints, unsubscribes, allowlist
- **Reporting**: Events, stats, metrics, tags, logs
- **Templates**: Email template management
- **Webhooks**: Webhook configuration and management
- **Mailing Lists**: List and member management
- **Routes**: Email routing rules
- **IP Management**: IPs, IP pools, IP allowlist
- **Account Management**: Subaccounts, users, credentials, keys, message limits

### Type Safety & Modern Swift
- Type-safe API with compile-time validation
- Swift concurrency with async/await throughout
- @Sendable closures for thread-safe operations
- Structured concurrency support
- Swift Testing framework for comprehensive test coverage

## Installation

### Recommended: Use swift-mailgun

For most users, install via the main entry point package:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-mailgun", from: "0.2.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "CoenttbMailgun", package: "swift-mailgun")
        ]
    )
]
```

### Direct Installation (Advanced)

If you only need the live implementation without additional integrations:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-mailgun-live", from: "0.1.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "Mailgun", package: "swift-mailgun-live")
        ]
    )
]
```

## Quick Start

### Environment Configuration

Set up your environment variables:

```bash
# Required
MAILGUN_BASE_URL=https://api.mailgun.net
MAILGUN_PRIVATE_API_KEY=your-api-key
MAILGUN_DOMAIN=mg.yourdomain.com

# Optional (for testing)
MAILGUN_FROM_EMAIL=noreply@yourdomain.com
MAILGUN_TO_EMAIL=test@example.com
```

### Basic Usage

```swift
import Dependencies
import Mailgun_Messages_Live

// Access the messages client via dependency injection
@Dependency(Mailgun.Messages.self) var messages

// Send a simple email
func sendWelcomeEmail(to email: EmailAddress) async throws {
    let request = Mailgun.Messages.Send.Request(
        from: try .init("welcome@yourdomain.com"),
        to: [try .init(email)],
        subject: "Welcome!",
        html: """
            <h1>Welcome to our service!</h1>
            <p>We're excited to have you on board.</p>
        """,
        text: "Welcome to our service! We're excited to have you on board."
    )

    let response = try await messages.client.send(request)
    print("Welcome email sent: \(response.id)")
}
```

### Using the Unified Client

```swift
import Dependencies
import Mailgun_Live

// Access all Mailgun features through the unified client
@Dependency(\.mailgun) var mailgun

func example() async throws {
    // Send a message
    let sendRequest = Mailgun.Messages.Send.Request(
        from: try .init("noreply@yourdomain.com"),
        to: [try .init("user@example.com")],
        subject: "Hello",
        text: "Hello from Mailgun!"
    )
    let sendResponse = try await mailgun.client.messages.send(sendRequest)

    // List domains
    let domainsResponse = try await mailgun.client.domains.list()

    // Check suppressions
    let bouncesResponse = try await mailgun.client.suppressions.bounces.list()
}
```

## Usage Examples

### Templates with Variables

```swift
@Dependency(Mailgun.Messages.self) var messages

let templateVariables = """
{
    "customer_name": "John Doe",
    "order_id": "12345",
    "total": "$99.99"
}
"""

let request = Mailgun.Messages.Send.Request(
    from: try .init("noreply@yourdomain.com"),
    to: [try .init("user@example.com")],
    subject: "Your Order",
    template: "order-confirmation",
    templateVersion: "v2",
    templateVariables: templateVariables
)

let response = try await messages.client.send(request)
```

### Batch Sending with Recipient Variables

```swift
@Dependency(Mailgun.Messages.self) var messages

let recipientVariables = try String(
    data: JSONEncoder().encode([
        "alice@example.com": ["name": "Alice", "code": "ALICE20"],
        "bob@example.com": ["name": "Bob", "code": "BOB15"]
    ]),
    encoding: .utf8
)!

let request = Mailgun.Messages.Send.Request(
    from: try .init("newsletter@yourdomain.com"),
    to: [
        try .init("alice@example.com"),
        try .init("bob@example.com")
    ],
    subject: "Hello %recipient.name%!",
    html: "<p>Special offer: Use code %recipient.code%</p>",
    recipientVariables: recipientVariables
)

let response = try await messages.client.send(request)
```

### Scheduled Delivery

```swift
@Dependency(Mailgun.Messages.self) var messages

let deliveryTime = Date().addingTimeInterval(3600) // 1 hour from now

let request = Mailgun.Messages.Send.Request(
    from: try .init("reminder@yourdomain.com"),
    to: [try .init("user@example.com")],
    subject: "Reminder: Meeting in 1 hour",
    text: "Don't forget about your meeting!",
    deliveryTime: deliveryTime
)

let response = try await messages.client.send(request)
```

### Attachments

```swift
@Dependency(Mailgun.Messages.self) var messages

let reportData = Data("Sample report content".utf8)

let attachment = Mailgun.Messages.Attachment.Data(
    data: reportData,
    filename: "report.pdf",
    contentType: "application/pdf"
)

let request = Mailgun.Messages.Send.Request(
    from: try .init("reports@yourdomain.com"),
    to: [try .init("manager@example.com")],
    subject: "Monthly Report",
    html: "<p>Please find the monthly report attached.</p>",
    attachments: [attachment]
)

let response = try await messages.client.send(request)
```

### Suppression Management

```swift
@Dependency(\.mailgun) var mailgun

// Check if an email is bounced
let bounces = try await mailgun.client.suppressions.bounces.list()
let isBounced = bounces.items.contains { $0.address.rawValue == "user@example.com" }

// Add to unsubscribe list
try await mailgun.client.suppressions.unsubscribe.create(
    .init(
        address: try .init("user@example.com"),
        tags: ["newsletter"]
    )
)

// Allowlist an important address
try await mailgun.client.suppressions.Allowlist.create(
    .address(try .init("vip@partner.com"))
)
```

### Analytics & Reporting

```swift
@Dependency(\.mailgun) var mailgun

// Get domain tags
let tags = try await mailgun.client.reporting.tags.list()

// Search events
let events = try await mailgun.client.reporting.events.list()
```

## Testing

The SDK includes comprehensive test coverage using Swift Testing framework with dependency injection.

### Test Configuration

Tests use environment variables for configuration. Create a `.env.development` file:

```bash
MAILGUN_BASE_URL=https://api.mailgun.net
MAILGUN_PRIVATE_API_KEY=your-test-api-key
MAILGUN_DOMAIN=sandbox-domain.mailgun.org
MAILGUN_FROM_EMAIL=test@sandbox-domain.mailgun.org
MAILGUN_TO_EMAIL=authorized@sandbox-domain.mailgun.org
```

### Writing Tests

```swift
import Testing
import DependenciesTestSupport
import Mailgun_Messages_Live

@Suite(
    "Email Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development)
)
struct EmailTests {
    @Test("Send test email")
    func testSendEmail() async throws {
        @Dependency(Mailgun.Messages.self) var messages

        let request = Mailgun.Messages.Send.Request(
            from: try .init("test@yourdomain.com"),
            to: [try .init("authorized@yourdomain.com")],
            subject: "Test Email",
            text: "This is a test",
            testMode: true  // Won't actually send
        )

        let response = try await messages.client.send(request)
        #expect(response.message.contains("Queued"))
    }
}
```

## Architecture

**swift-mailgun-live** is part of a three-package ecosystem:

```
┌─────────────────────────────────────────────────────────┐
│                   swift-mailgun                         │
│         (User-facing package with integrations)         │
│                                                         │
│  • SwiftUI components                                   │
│  • HTML email templates                                 │
│  • Re-exports swift-mailgun-live                       │
│  • Additional convenience features                      │
└─────────────────────────────────────────────────────────┘
                            │
                      imports/uses
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  swift-mailgun-live                     │
│              (Live implementation layer)                │
│                                                         │
│  • URLSession networking                                │
│  • Authentication handling                              │
│  • Dependency injection                                 │
│  • Production-ready clients                             │
└─────────────────────────────────────────────────────────┘
                            │
                       implements
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  swift-mailgun-types                    │
│            (Type definitions & interfaces)              │
│                                                         │
│  • Domain models                                        │
│  • Client protocols                                     │
│  • API route definitions                                │
│  • Shared utilities                                     │
└─────────────────────────────────────────────────────────┘
```

### Key Components

- **Modular Features**: Each API feature (Messages, Domains, etc.) is a separate module
- **Dependency Injection**: Deep integration with swift-dependencies
- **Type Safety**: All API interactions validated at compile time
- **Error Handling**: Comprehensive error types with detailed messages
- **Testing**: Real API integration tests with test mode support

## Related Packages

### Dependencies

- [swift-authenticating](https://github.com/coenttb/swift-authenticating): A Swift package for type-safe HTTP authentication with URL routing integration.
- [swift-environment-variables](https://github.com/coenttb/swift-environment-variables): A Swift package for type-safe environment variable management.
- [swift-mailgun-types](https://github.com/coenttb/swift-mailgun-types): A Swift package with foundational types for Mailgun.
- [swift-url-form-coding](https://github.com/coenttb/swift-url-form-coding): A Swift package for type-safe web form encoding and decoding.
- [swift-urlrequest-handler](https://github.com/coenttb/swift-urlrequest-handler): A Swift package for URLRequest handling with structured error handling.

### Used By

- [swift-mailgun](https://github.com/coenttb/swift-mailgun): The Swift library for the Mailgun API.

### Third-Party Dependencies

- [pointfreeco/swift-dependencies](https://github.com/pointfreeco/swift-dependencies): A dependency management library for controlling dependencies in Swift.
- [pointfreeco/swift-url-routing](https://github.com/pointfreeco/swift-url-routing): A bidirectional URL router with more type safety and less fuss.
- [pointfreeco/xctest-dynamic-overlay](https://github.com/pointfreeco/xctest-dynamic-overlay): Define XCTest assertion helpers directly in production code.

## Example Projects

See the Mailgun SDK ecosystem in action:

- [coenttb.com](https://github.com/coenttb/coenttb-com-server) - Production website using swift-mailgun
- [coenttb-newsletter](https://github.com/coenttb/coenttb-newsletter) - Newsletter system built with swift-mailgun

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

- [Issues](https://github.com/coenttb/swift-mailgun-live/issues) - Report bugs or request features
- [Discussions](https://github.com/coenttb/swift-mailgun-live/discussions) - Ask questions
- [Newsletter](http://coenttb.com/en/newsletter/subscribe) - Get updates
- [X (Twitter)](http://x.com/coenttb) - Follow for news
- [LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp) - Connect

## License

This project is available under dual licensing:

### Open Source License
**GNU Affero General Public License v3.0 (AGPL-3.0)**
Free for open source projects. See [LICENSE](LICENSE) for details.

### Commercial License
For proprietary/commercial use without AGPL restrictions.
Contact **info@coenttb.com** for licensing options.

---

<p align="center">
  Made by <a href="https://coenttb.com">coenttb</a>
</p>
