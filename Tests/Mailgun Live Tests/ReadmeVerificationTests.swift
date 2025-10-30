//
//  ReadmeVerificationTests.swift
//  swift-mailgun-live
//
//  Created to verify README code examples compile and execute correctly
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Live
import Mailgun_Messages_Live
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - README Line 103-125: Basic Usage with Messages Client

@Suite("README Basic Usage - Lines 103-125")
struct ReadmeBasicUsageTests {
    @Test("Basic email sending with Messages client")
    func testBasicUsage() async throws {
        // This validates the README example starting at line 103
        // import Dependencies
        // import Mailgun_Messages_Live

        // Mock the dependency for compilation test
        try await withDependencies {
            $0.context = .test
        } operation: {
            @Dependency(Mailgun.Messages.self) var messages

            func sendWelcomeEmail(to email: EmailAddress) async throws {
                let request = Mailgun.Messages.Send.Request(
                    from: try .init("welcome@yourdomain.com"),
                    to: [email],
                    subject: "Welcome!",
                    html: """
                        <h1>Welcome to our service!</h1>
                        <p>We're excited to have you on board.</p>
                    """,
                    text: "Welcome to our service! We're excited to have you on board."
                )

                // Verify request is properly formed
                #expect(request.from.rawValue == "welcome@yourdomain.com")
                #expect(request.subject == "Welcome!")
                #expect(request.html != nil)
                #expect(request.text != nil)
            }

            // Test compiles and request can be created
            try await sendWelcomeEmail(to: try .init("test@example.com"))
        }
    }
}

// MARK: - README Line 129-152: Unified Client Usage

@Suite("README Unified Client - Lines 129-152")
struct ReadmeUnifiedClientTests {
    @Test("Using the unified Mailgun client")
    func testUnifiedClient() async throws {
        // This validates the README example starting at line 129
        try await withDependencies {
            $0.context = .test
        } operation: {
            @Dependency(\.mailgun) var mailgun

            func example() async throws {
                // Send a message
                let sendRequest = Mailgun.Messages.Send.Request(
                    from: try .init("noreply@yourdomain.com"),
                    to: [try .init("user@example.com")],
                    subject: "Hello",
                    text: "Hello from Mailgun!"
                )

                // Verify request structure
                #expect(sendRequest.from.rawValue == "noreply@yourdomain.com")
                #expect(sendRequest.subject == "Hello")
                #expect(sendRequest.text == "Hello from Mailgun!")

                // Verify client structure exists (compilation test)
                _ = mailgun.client.messages
                _ = mailgun.client.domains
                _ = mailgun.client.suppressions
            }

            try await example()
        }
    }
}

// MARK: - README Line 159-179: Templates with Variables

@Suite("README Templates - Lines 159-179")
struct ReadmeTemplatesTests {
    @Test("Templates with variables")
    func testTemplatesWithVariables() async throws {
        // This validates the README example starting at line 159
        try await withDependencies {
            $0.context = .test
        } operation: {
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

            // Verify template configuration
            #expect(request.template == "order-confirmation")
            #expect(request.templateVersion == "v2")
            #expect(request.templateVariables != nil)
        }
    }
}

// MARK: - README Line 184-206: Batch Sending with Recipient Variables

@Suite("README Batch Sending - Lines 184-206")
struct ReadmeBatchSendingTests {
    @Test("Batch sending with recipient variables")
    func testBatchSending() async throws {
        // This validates the README example starting at line 184
        try await withDependencies {
            $0.context = .test
        } operation: {
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

            // Verify batch configuration
            #expect(request.to.count == 2)
            #expect(request.recipientVariables != nil)
            #expect(request.subject.contains("%recipient.name%"))
        }
    }
}

// MARK: - README Line 210-224: Scheduled Delivery

@Suite("README Scheduled Delivery - Lines 210-224")
struct ReadmeScheduledDeliveryTests {
    @Test("Scheduled delivery")
    func testScheduledDelivery() throws {
        // This validates the README example starting at line 210
        @Dependency(Mailgun.Messages.self) var messages

        let deliveryTime = Date().addingTimeInterval(3600) // 1 hour from now

        let request = Mailgun.Messages.Send.Request(
            from: try .init("reminder@yourdomain.com"),
            to: [try .init("user@example.com")],
            subject: "Reminder: Meeting in 1 hour",
            text: "Don't forget about your meeting!",
            deliveryTime: deliveryTime
        )

        // Verify scheduled delivery
        #expect(request.deliveryTime != nil)
        #expect(request.subject == "Reminder: Meeting in 1 hour")
    }
}

// MARK: - README Line 229-248: Attachments

@Suite("README Attachments - Lines 229-248")
struct ReadmeAttachmentsTests {
    @Test("Email with attachments")
    func testAttachments() throws {
        // This validates the README example starting at line 229
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

        // Verify attachment configuration
        #expect(request.attachments != nil)
        #expect(request.attachments?.count == 1)
        #expect(request.attachments?.first?.filename == "report.pdf")
    }
}

// MARK: - README Line 253-271: Suppression Management

@Suite("README Suppressions - Lines 253-271")
struct ReadmeSuppressionsTests {
    @Test("Suppression management")
    func testSuppressionManagement() throws {
        // This validates the README example starting at line 253
        @Dependency(\.mailgun) var mailgun

        // Test client structure exists
        _ = mailgun.client.suppressions.bounces
        _ = mailgun.client.suppressions.unsubscribe
        _ = mailgun.client.suppressions.Allowlist

        // Verify request types compile
        let unsubscribeRequest = Mailgun.Suppressions.Unsubscribe.Create.Request(
            address: try .init("user@example.com"),
            tags: ["newsletter"]
        )
        #expect(unsubscribeRequest.address.rawValue == "user@example.com")
        #expect(unsubscribeRequest.tags == ["newsletter"])

        let allowlistRequest = Mailgun.Suppressions.Allowlist.Create.Request.address(
            try .init("vip@partner.com")
        )
        if case .address(let email) = allowlistRequest {
            #expect(email.rawValue == "vip@partner.com")
        }
    }
}

// MARK: - README Line 276-283: Analytics & Reporting

@Suite("README Analytics - Lines 276-283")
struct ReadmeAnalyticsTests {
    @Test("Analytics and reporting")
    func testAnalytics() throws {
        // This validates the README example starting at line 276
        @Dependency(\.mailgun) var mailgun

        // Verify client structure exists
        _ = mailgun.client.reporting.tags
        _ = mailgun.client.reporting.events
    }
}

// MARK: - README Line 304-330: Testing Example

@Suite("README Testing Example - Lines 304-330")
struct ReadmeTestingExampleTests {
    @Test("Testing example from README")
    func testTestingExample() throws {
        // This validates the README testing example starting at line 304
        @Dependency(Mailgun.Messages.self) var messages

        let request = Mailgun.Messages.Send.Request(
            from: try .init("test@yourdomain.com"),
            to: [try .init("authorized@yourdomain.com")],
            subject: "Test Email",
            text: "This is a test",
            testMode: true  // Won't actually send
        )

        // Verify test mode is set
        #expect(request.testMode == true)
        #expect(request.from.rawValue == "test@yourdomain.com")
        #expect(request.subject == "Test Email")
    }
}

// MARK: - Additional Verification Tests

@Suite("README Module Imports Verification")
struct ReadmeModuleImportsTests {
    @Test("Verify module imports compile")
    func testModuleImports() throws {
        // Verify all module imports from README examples work

        // From line 104: import Mailgun_Messages_Live
        @Dependency(Mailgun.Messages.self) var messages
        _ = messages

        // From line 131: import Mailgun_Live
        @Dependency(\.mailgun) var mailgun
        _ = mailgun

        // From line 306: import Mailgun_Messages_Live
        // Already tested above

        _ = true // Compilation success
    }
}

@Suite("README Type Safety Verification")
struct ReadmeTypeSafetyTests {
    @Test("EmailAddress type safety")
    func testEmailAddressTypeSafety() throws {
        // Verify EmailAddress initialization patterns from README
        let validEmail = try EmailAddress("test@example.com")
        #expect(validEmail.rawValue == "test@example.com")

        // Verify .init() pattern works
        let validEmail2 = try EmailAddress.init("test2@example.com")
        #expect(validEmail2.rawValue == "test2@example.com")
    }

    @Test("Request type structure")
    func testRequestTypeStructure() throws {
        // Verify Mailgun.Messages.Send.Request structure
        let request = Mailgun.Messages.Send.Request(
            from: try .init("from@example.com"),
            to: [try .init("to@example.com")],
            subject: "Test",
            text: "Body"
        )

        #expect(request.from.rawValue == "from@example.com")
        #expect(request.to.count == 1)
        #expect(request.subject == "Test")
        #expect(request.text == "Body")
    }
}

@Suite("README Client Structure Verification")
struct ReadmeClientStructureTests {
    @Test("Unified client structure")
    func testUnifiedClientStructure() throws {
        @Dependency(\.mailgun) var mailgun

        // Verify all client properties exist as shown in README
        _ = mailgun.client.messages
        _ = mailgun.client.domains
        _ = mailgun.client.suppressions
        _ = mailgun.client.reporting
        _ = mailgun.client.templates
        _ = mailgun.client.webhooks
        _ = mailgun.client.mailingLists
        _ = mailgun.client.routes
        _ = mailgun.client.ips
        _ = mailgun.client.ipPools
        _ = mailgun.client.ipAllowlist
        _ = mailgun.client.keys
        _ = mailgun.client.users
        _ = mailgun.client.subaccounts
        _ = mailgun.client.credentials
        _ = mailgun.client.customMessageLimit
        _ = mailgun.client.accountManagement

        _ = true // All properties accessible
    }

    @Test("Suppressions subclient structure")
    func testSuppressionsSubclientStructure() throws {
        @Dependency(\.mailgun) var mailgun

        // Verify suppressions subclients as shown in README
        _ = mailgun.client.suppressions.bounces
        _ = mailgun.client.suppressions.complaints
        _ = mailgun.client.suppressions.unsubscribe
        _ = mailgun.client.suppressions.Allowlist

        _ = true // All subclients accessible
    }

    @Test("Reporting subclient structure")
    func testReportingSubclientStructure() throws {
        @Dependency(\.mailgun) var mailgun

        // Verify reporting subclients as shown in README
        _ = mailgun.client.reporting.tags
        _ = mailgun.client.reporting.events

        _ = true // All subclients accessible
    }
}
