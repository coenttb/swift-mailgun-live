# swift-mailgun-live

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/Platforms-macOS%2014%2B%20|%20iOS%2017%2B-lightgray.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/Tests-238%20Passing-brightgreen.svg" alt="Tests">
  <img src="https://img.shields.io/badge/Coverage-100%25%20APIs-brightgreen.svg" alt="API Coverage">
  <img src="https://img.shields.io/badge/License-AGPL--3.0%20|%20Commercial-blue.svg" alt="License">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-green.svg" alt="Status">
  <img src="https://img.shields.io/badge/Version-0.1.0-brightgreen.svg" alt="Version">
</p>

<p align="center">
  <strong>Live implementation layer for swift-mailgun-types</strong><br>
  Production-ready URLSession networking with comprehensive API coverage
</p>

## Overview

**swift-mailgun-live** provides the production-ready, live implementations for the types and interfaces defined in [swift-mailgun-types](https://github.com/coenttb/swift-mailgun-types). This package transforms the type-safe contracts into a fully functional Mailgun SDK with URLSession-based networking, authentication, and comprehensive test coverage.

> **Note:** For most users, we recommend using [swift-mailgun](https://github.com/coenttb/swift-mailgun) which provides a complete, user-friendly package that includes this implementation along with additional integrations for SwiftUI, HTML rendering, and more.

```swift
// Direct usage (for advanced users)
import Mailgun  // from swift-mailgun-live

@Dependency(\.mailgun) var mailgun

// Send a simple email
let request = Mailgun.Messages.Send.Request(
    from: try .init("hello@yourdomain.com"),
    to: [try .init("user@example.com")],
    subject: "Modern, type-safe Swift SDK for Mailgun!",
    html: "<h1>Production-ready</h1><p>Fully tested</p>"
)

let response = try await mailgun.client.messages.send(request)
print("Email sent: \(response.id) ✅")
```

## Features

### 🚀 Production Ready
- **URLSession-based networking** with robust error handling
- **Basic Authentication** via swift-authenticating
- **Environment configuration** via swift-environment-variables
- **Dependency injection** via swift-dependencies
- **Swift 6 language mode** with complete concurrency support

### 📋 Complete API Coverage

| Feature | Implementation | Tests | Status |
|---------|:--------------:|:-----:|:------:|
| **Messages** | ✅ | ✅ | Production |
| **Domains** | ✅ | ✅ | Production |
| ├─ DKIM Security | ✅ | ✅ | Ready |
| ├─ Connection Settings | ✅ | ✅ | Ready |
| ├─ Domain Keys | ✅ | ✅ | Ready |
| └─ Tracking Settings | ✅ | ✅ | Ready |
| **Suppressions** | ✅ | ✅ | Production |
| ├─ Bounces | ✅ | ✅ | Ready |
| ├─ Complaints | ✅ | ✅ | Ready |
| ├─ Unsubscribes | ✅ | ✅ | Ready |
| └─ Allowlist | ✅ | ✅ | Ready |
| **Reporting** | ✅ | ✅ | Production |
| ├─ Events | ✅ | ✅ | Ready |
| ├─ Stats | ✅ | ✅ | Ready |
| ├─ Metrics | ✅ | ✅ | Ready |
| ├─ Tags | ✅ | ✅ | Ready |
| └─ Logs | ✅ | ✅ | Ready |
| **Templates** | ✅ | ✅ | Production |
| **Webhooks** | ✅ | ✅ | Production |
| **Mailing Lists** | ✅ | ✅ | Production |
| **Routes** | ✅ | ✅ | Ready |
| **IP Management** | ✅ | ✅ | Ready |
| ├─ IPs | ✅ | ✅ | Ready |
| ├─ IP Pools | ✅ | ✅ | Ready |
| └─ IP Allowlist | ✅ | ✅ | Ready |
| **Account Management** | ✅ | ✅ | Ready |
| ├─ Subaccounts | ✅ | ✅ | Ready |
| ├─ Users | ✅ | ✅ | Ready |
| ├─ Credentials | ✅ | ✅ | Ready |
| ├─ Keys | ✅ | ✅ | Ready |
| └─ Message Limits | ✅ | ✅ | Ready |

**Legend**: Production = Used in production | Ready = Fully tested and ready for production use

### 🛡️ Type Safety & Modern Swift
- **Type-safe API** with compile-time validation
- **Swift concurrency** with async/await throughout
- **@Sendable closures** for thread-safe operations
- **Structured concurrency** support
- **Swift Testing framework** for comprehensive test coverage

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
MAILGUN_TEST_MAILINGLIST=newsletter@mg.yourdomain.com
MAILGUN_TEST_RECIPIENT=subscriber@example.com
```

### Basic Usage

```swift
import Dependencies
import Mailgun

// Access the client via dependency injection
@Dependency(\.mailgun) var mailgun

// Send a simple email
func sendWelcomeEmail(to email: EmailAddress) async throws {
    let request = Mailgun.Messages.Send.Request(
        from: .init("welcome@yourdomain.com"),
        to: [.init(email)],
        subject: "Welcome!",
        html: """
            <h1>Welcome to our service!</h1>
            <p>We're excited to have you on board.</p>
        """,
        text: "Welcome to our service! We're excited to have you on board."
    )
    
    let response = try await mailgun.client.messages.send(request)
    print("Welcome email sent: \(response.id)")
}
```

### Advanced Features

#### Templates with Variables

```swift
let request = Mailgun.Messages.Send.Request(
    from: .init("noreply@yourdomain.com"),
    to: [.init("user@example.com")],
    subject: "Your Order #{{order_id}}",
    template: "order-confirmation",
    templateVariables: [
        "customer_name": "John Doe",
        "order_id": "12345",
        "total": "$99.99",
        "items": ["Swift Book", "Mailgun Guide"]
    ],
    templateVersion: "v2"
)

let response = try await mailgun.client.messages.send(request)
```

#### Batch Sending with Recipient Variables

```swift
let request = Mailgun.Messages.Send.Request(
    from: .init("newsletter@yourdomain.com"),
    to: [
        .init("alice@example.com"),
        .init("bob@example.com"),
        .init("charlie@example.com")
    ],
    subject: "Hello %recipient.name%!",
    html: "<p>Special offer just for %recipient.name%: Use code %recipient.code%</p>",
    recipientVariables: [
        "alice@example.com": ["name": "Alice", "code": "ALICE20"],
        "bob@example.com": ["name": "Bob", "code": "BOB15"],
        "charlie@example.com": ["name": "Charlie", "code": "CHARLIE25"]
    ]
)
```

#### Scheduled Delivery

```swift
let deliveryTime = Date().addingTimeInterval(3600) // 1 hour from now

let request = Mailgun.Messages.Send.Request(
    from: .init("reminder@yourdomain.com"),
    to: [.init("user@example.com")],
    subject: "Reminder: Meeting in 1 hour",
    text: "Don't forget about your meeting!",
    deliveryTime: deliveryTime
)
```

#### Attachments

```swift
let attachment = Mailgun.Messages.Attachment(
    filename: "report.pdf",
    data: reportData,
    contentType: "application/pdf"
)

let request = Mailgun.Messages.Send.Request(
    from: .init("reports@yourdomain.com"),
    to: [.init("manager@example.com")],
    subject: "Monthly Report",
    html: "<p>Please find the monthly report attached.</p>",
    attachment: [attachment]
)
```

### Suppression Management

```swift
// Check if an email is bounced
let bounces = try await mailgun.client.suppressions.bounces.list()
let isBounced = bounces.items.contains { $0.address == "user@example.com" }

// Add to unsubscribe list
try await mailgun.client.suppressions.unsubscribes.create(
    address: "user@example.com",
    tag: "newsletter"
)

// Allowlist an important address
try await mailgun.client.suppressions.Allowlist.create(
    address: "vip@partner.com",
    reason: "Important business partner"
)
```

### Analytics & Reporting

```swift
// Get delivery statistics
let stats = try await mailgun.client.stats.total(
    event: .delivered,
    start: Date().addingTimeInterval(-7 * 24 * 3600), // Last 7 days
    resolution: .day
)

// Search events
let events = try await mailgun.client.events.search(
    recipient: "user@example.com",
    limit: 50
)

// Get metrics
let metrics = try await mailgun.client.metrics.query(
    metrics: [.deliverability.deliveredRate],
    start: Date().addingTimeInterval(-30 * 24 * 3600),
    resolution: .day
)
```

## Integration Examples

### With Vapor

```swift
import Vapor
import Mailgun
import Dependencies

extension Request {
    var mailgun: Mailgun.Client.Authenticated {
        @Dependency(\.mailgun) var mailgun
        return mailgun
    }
}

func routes(_ app: Application) throws {
    app.post("send-welcome") { req async throws -> HTTPStatus in
        let user = try req.content.decode(User.self)
        
        @Dependency(\.mailgun) var mailgun
        
        let email = Mailgun.Messages.Send.Request(
            from: .init("welcome@app.com"),
            to: [.init(user.email)],
            subject: "Welcome to our app!",
            template: "welcome",
            templateVariables: [
                "name": user.name,
                "activation_link": "https://app.com/activate/\(user.id)"
            ]
        )
        
        try await mailgun.client.messages.send(email)
        return .ok
    }
}
```

### With SwiftUI

```swift
import SwiftUI
import Dependencies
import Mailgun

@MainActor
@Observable
class ContactViewModel {
    @ObservationIgnored
    @Dependency(\.mailgun) var mailgun
    
    var isLoading = false
    var message = ""
    var error: Error?
    
    func sendContactForm(name: String, email: EmailAddress, message: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = Mailgun.Messages.Send.Request(
                from: .init(email),
                to: [.init("contact@company.com")],
                subject: "Contact Form: \(name)",
                text: message,
                replyTo: .init(email)
            )
            
            let response = try await mailgun.client.messages.send(request)
            self.message = "Message sent successfully!"
        } catch {
            self.error = error
        }
    }
}
```

## Testing

The SDK includes comprehensive test coverage with **238 tests** - all passing! ✅

### Test Coverage

| Category | Tests | Status |
|----------|------:|:------:|
| **Messages** | 45 | ✅ |
| **Suppressions** | 28 | ✅ |
| **Domains** | 22 | ✅ |
| **Templates** | 15 | ✅ |
| **Webhooks** | 12 | ✅ |
| **Routes** | 10 | ✅ |
| **Lists** | 18 | ✅ |
| **IP Management** | 25 | ✅ |
| **Reporting** | 20 | ✅ |
| **Account Management** | 15 | ✅ |
| **Other Features** | 28 | ✅ |
| **Total** | **238** | **100% Passing** |

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

The SDK uses Swift Testing framework with dependency injection:

```swift
import Testing
import DependenciesTestSupport
import Mailgun

@Suite(
    "Email Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development)
)
struct EmailTests {
    @Test("Send test email")
    func testSendEmail() async throws {
        @Dependency(\.mailgun) var mailgun
        
        let request = Mailgun.Messages.Send.Request(
            from: .init("test@yourdomain.com"),
            to: [.init("authorized@yourdomain.com")],
            subject: "Test Email",
            text: "This is a test",
            testMode: true  // Won't actually send
        )
        
        let response = try await mailgun.client.messages.send(request)
        #expect(response.message.contains("Queued"))
    }
}
```

### Sandbox Testing

For sandbox domains, ensure you've added authorized recipients:

```swift
// Helper to get authorized sandbox recipients
func getAuthorizedRecipients() async throws -> [EmailAddress] {
    @Dependency(\.mailgun) var mailgun
    
    let response = try await mailgun.client.accountManagement.getSandboxAuthRecipients()
    return response.recipients
        .filter(\.activated)
        .map(\.email)
}
```

### Test Utilities

The package includes helpful test utilities:

- **Sandbox Reset Test**: Clean up test data while preserving authorized recipients
- **Integration Tests**: Real API tests with authorized recipients

## Architecture

**swift-mailgun-live** is part of a three-package ecosystem:

```
┌─────────────────────────────────────────────────────────┐
│                   swift-mailgun                       │
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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Example Projects

See the Mailgun SDK ecosystem in action:

- [coenttb.com](https://github.com/coenttb/coenttb-com-server) - Production website using swift-mailgun
- [coenttb-newsletter](https://github.com/coenttb/coenttb-newsletter) - Newsletter system built with swift-mailgun

## Support

- 🐛 [Issues](https://github.com/coenttb/swift-mailgun-live/issues) - Report bugs or request features
- 💬 [Discussions](https://github.com/coenttb/swift-mailgun-live/discussions) - Ask questions
- 📧 [Newsletter](http://coenttb.com/en/newsletter/subscribe) - Get updates
- 🐦 [X (Twitter)](http://x.com/coenttb) - Follow for news
- 💼 [LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp) - Connect

## License

This project is available under **dual licensing**:

### Open Source License
**GNU Affero General Public License v3.0 (AGPL-3.0)**  
Free for open source projects. See [LICENSE](LICENSE) for details.

### Commercial License
For proprietary/commercial use without AGPL restrictions.  
Contact **info@coenttb.com** for licensing options.

---

<p align="center">
  Made with ❤️ by <a href="https://coenttb.com">coenttb</a>
</p>
