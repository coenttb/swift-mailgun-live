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
@_exported import Mailgun_Subaccounts_Types

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension Mailgun.Subaccounts.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Mailgun.Subaccounts.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

    return Self(
      get: { subaccountId in
        try await handleRequest(
          for: makeRequest(.get(subaccountId: subaccountId)),
          decodingTo: Mailgun.Subaccounts.Get.Response.self
        )
      },
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Mailgun.Subaccounts.List.Response.self
        )
      },
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Mailgun.Subaccounts.Create.Response.self
        )
      },
      delete: { subaccountId in
        try await handleRequest(
          for: makeRequest(.delete(subaccountId: subaccountId)),
          decodingTo: Mailgun.Subaccounts.Delete.Response.self
        )
      },
      disable: { subaccountId, request in
        try await handleRequest(
          for: makeRequest(.disable(subaccountId: subaccountId, request: request)),
          decodingTo: Mailgun.Subaccounts.Disable.Response.self
        )
      },
      enable: { subaccountId in
        try await handleRequest(
          for: makeRequest(.enable(subaccountId: subaccountId)),
          decodingTo: Mailgun.Subaccounts.Enable.Response.self
        )
      },
      getCustomLimit: { subaccountId in
        try await handleRequest(
          for: makeRequest(.getCustomLimit(subaccountId: subaccountId)),
          decodingTo: Mailgun.Subaccounts.CustomLimit.Get.Response.self
        )
      },
      updateCustomLimit: { subaccountId, limit in
        try await handleRequest(
          for: makeRequest(.updateCustomLimit(subaccountId: subaccountId, limit: limit)),
          decodingTo: Mailgun.Subaccounts.CustomLimit.Update.Response.self
        )
      },
      deleteCustomLimit: { subaccountId in
        try await handleRequest(
          for: makeRequest(.deleteCustomLimit(subaccountId: subaccountId)),
          decodingTo: Mailgun.Subaccounts.CustomLimit.Delete.Response.self
        )
      },
      updateFeatures: { subaccountId, request in
        try await handleRequest(
          for: makeRequest(.updateFeatures(subaccountId: subaccountId, request: request)),
          decodingTo: Mailgun.Subaccounts.Features.Update.Response.self
        )
      }
    )
  }
}

extension Mailgun.Subaccounts {
  public typealias Authenticated = Mailgun_Shared_Live.Authenticated<
    Mailgun.Subaccounts.API,
    Mailgun.Subaccounts.API.Router,
    Mailgun.Subaccounts.Client
  >
}

extension Mailgun.Subaccounts: @retroactive DependencyKey {
  public static var liveValue: Mailgun.Subaccounts.Authenticated {
    try! Mailgun.Subaccounts.Authenticated { .live(makeRequest: $0) }
  }
}

extension Mailgun.Subaccounts.API.Router: @retroactive DependencyKey {
  public static let liveValue: Mailgun.Subaccounts.API.Router = .init()
}
