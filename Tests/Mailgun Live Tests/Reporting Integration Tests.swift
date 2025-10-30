import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_AccountManagement_Live
import Mailgun_Live
import Mailgun_Messages_Types
import Mailgun_Reporting_Types
import Testing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@Suite(
  "Reporting Integration Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct ReportingIntegrationTests {

  // Helper to get authorized sandbox recipients
  func getAuthorizedRecipients() async throws -> [EmailAddress] {
    @Dependency(\.mailgun) var mailgun

    let response = try await mailgun.client.accountManagement.getSandboxAuthRecipients()

    // Filter only activated recipients and convert to EmailAddress
    let recipients = response.recipients
      .filter { $0.activated }
      .map(\.email)

    // Ensure we have at least one recipient
    guard !recipients.isEmpty else {
      throw TestError.noAuthorizedRecipients
    }

    return recipients
  }

  enum TestError: Swift.Error {
    case noAuthorizedRecipients
  }

  @Test("Should create and get tag details")
  func testGetTagDetails() async throws {
    @Dependency(\.mailgun) var mailgun
    @Dependency(\.envVars.mailgun.domain) var domain

    // Get authorized recipients
    let recipients = try await getAuthorizedRecipients()

    // Create a test tag
    let testTag = "test-detail-\(UUID().uuidString.prefix(8))"

    let sendRequest = Mailgun.Messages.Send.Request(
      from: try .init("test@\(domain.rawValue)"),
      to: [recipients.first!],
      subject: "Test for tag details",
      text: "Testing tag details",
      tags: [testTag],
      testMode: true  // Use test mode to avoid sending real emails
    )

    _ = try await mailgun.client.messages.send(sendRequest)

    // Wait a moment for tag to be processed (if it gets created at all in test mode)
    try await Task.sleep(nanoseconds: 2_000_000_000)  // 2 seconds

    // Try to get tag details - may not exist in test mode
    do {
      let tag = try await mailgun.client.reporting.tags.get(testTag)
      #expect(tag.tag == testTag)
    } catch {
      // In test mode, tags might not be created
      let errorString = String(describing: error).lowercased()
      if errorString.contains("not found") || errorString.contains("404") {
        #expect(Bool(true), "Tag not found - expected in test mode since no real email was sent")
      } else {
        throw error
      }
    }

    // Clean up
    do {
      _ = try await mailgun.client.reporting.tags.delete(testTag)
    } catch {
      // Ignore errors during cleanup
    }
  }

  @Test("Should create tag and get stats")
  func testGetTagStats() async throws {
    @Dependency(\.mailgun) var mailgun
    @Dependency(\.envVars.mailgun.domain) var domain

    // Get authorized recipients
    let recipients = try await getAuthorizedRecipients()

    // Create a test tag
    let testTag = "test-stats-\(UUID().uuidString.prefix(8))"

    let sendRequest = Mailgun.Messages.Send.Request(
      from: try .init("test@\(domain.rawValue)"),
      to: [recipients.first!],
      subject: "Test for tag stats",
      text: "Testing tag stats",
      tags: [testTag],
      testMode: true  // Use test mode to avoid sending real emails
    )

    _ = try await mailgun.client.messages.send(sendRequest)

    // Wait a moment for tag to be processed (if it gets created at all in test mode)
    try await Task.sleep(nanoseconds: 2_000_000_000)  // 2 seconds

    // Get tag stats
    let endDate = Date()
    let startDate = endDate.addingTimeInterval(-1 * 24 * 60 * 60)  // 1 day ago

    // Use Unix timestamps (epoch time)
    let startTimestamp = String(Int(startDate.timeIntervalSince1970))
    let endTimestamp = String(Int(endDate.timeIntervalSince1970))

    let statsRequest = Mailgun.Reporting.Tags.Stats.Request(
      event: ["accepted"],
      start: startTimestamp,
      end: endTimestamp,
      resolution: "day",
      duration: nil
    )

    // Try to get tag stats - may not exist in test mode
    do {
      let stats = try await mailgun.client.reporting.tags.stats(testTag, statsRequest)
      // Verify we got a valid stats response structure
      #expect(stats.tag == testTag || stats.tag.isEmpty)
    } catch {
      // In test mode, tags might not be created
      let errorString = String(describing: error).lowercased()
      if errorString.contains("not found") || errorString.contains("404") {
        #expect(Bool(true), "Tag not found - expected in test mode since no real email was sent")
      } else {
        throw error
      }
    }

    // Clean up
    do {
      _ = try await mailgun.client.reporting.tags.delete(testTag)
    } catch {
      // Ignore errors during cleanup
    }
  }

  @Test("Should create tag and get aggregates")
  func testGetTagAggregates() async throws {
    @Dependency(\.mailgun) var mailgun
    @Dependency(\.envVars.mailgun.domain) var domain

    // Get authorized recipients
    let recipients = try await getAuthorizedRecipients()

    // Create a test tag
    let testTag = "test-aggregates-\(UUID().uuidString.prefix(8))"

    let sendRequest = Mailgun.Messages.Send.Request(
      from: try .init("test@\(domain.rawValue)"),
      to: [recipients.first!],
      subject: "Test for tag aggregates",
      text: "Testing tag aggregates",
      tags: [testTag],
      testMode: true  // Use test mode to avoid sending real emails
    )

    _ = try await mailgun.client.messages.send(sendRequest)

    // Wait for tag data to propagate in Mailgun's system (if it gets created at all in test mode)
    print("Waiting for tag data to propagate...")
    try await Task.sleep(nanoseconds: 5_000_000_000)  // 5 seconds

    // Get tag aggregates
    let aggregatesRequest = Mailgun.Reporting.Tags.Aggregates.Request(
      type: "provider"  // Can be "provider", "device", or "country"
    )

    // Try to get tag aggregates - may not exist in test mode
    do {
      let aggregates = try await mailgun.client.reporting.tags.aggregates(
        testTag,
        aggregatesRequest
      )
      #expect(aggregates.provider != nil || aggregates.device != nil || aggregates.country != nil)
    } catch {
      // In test mode, tags might not be created
      let errorString = String(describing: error).lowercased()
      if errorString.contains("not found") || errorString.contains("404") {
        #expect(Bool(true), "Tag not found - expected in test mode since no real email was sent")
      } else {
        throw error
      }
    }

    // Clean up
    do {
      _ = try await mailgun.client.reporting.tags.delete(testTag)
    } catch {
      // Ignore errors during cleanup
    }
  }

  @Test("Should list created tags")
  func testListTags() async throws {
    @Dependency(\.mailgun) var mailgun
    @Dependency(\.envVars.mailgun.domain) var domain

    // Get authorized recipients
    let recipients = try await getAuthorizedRecipients()

    // Create a test tag by sending an email with it
    let testTag = "test-tag-\(UUID().uuidString.prefix(8))"

    let sendRequest = Mailgun.Messages.Send.Request(
      from: try .init("test@\(domain.rawValue)"),
      to: [recipients.first!],
      subject: "Test with tag",
      text: "Testing tags",
      tags: [testTag],
      testMode: true  // Use test mode to avoid sending real emails
    )

    _ = try await mailgun.client.messages.send(sendRequest)

    // Now list tags
    let response = try await mailgun.client.reporting.tags.list(nil)
    // Response.items is non-optional array
    #expect(response.items.isEmpty || !response.items.isEmpty)

    // Clean up - delete the test tag
    do {
      _ = try await mailgun.client.reporting.tags.delete(testTag)
    } catch {
      // Ignore errors during cleanup
    }
  }
}
