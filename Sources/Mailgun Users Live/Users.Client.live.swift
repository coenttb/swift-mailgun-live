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
@_exported import Mailgun_Users_Types

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension Mailgun.Users.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Mailgun.Users.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

    return Self(
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Mailgun.Users.List.Response.self
        )
      },
      get: { userId in
        try await handleRequest(
          for: makeRequest(.get(userId: userId)),
          decodingTo: Mailgun.Users.Get.Response.self
        )
      },
      me: {
        try await handleRequest(
          for: makeRequest(.me),
          decodingTo: Mailgun.Users.Me.Response.self
        )
      },
      addToOrganization: { userId, orgId in
        try await handleRequest(
          for: makeRequest(.addToOrganization(userId: userId, orgId: orgId)),
          decodingTo: Mailgun.Users.Organization.Add.Response.self
        )
      },
      removeFromOrganization: { userId, orgId in
        try await handleRequest(
          for: makeRequest(.removeFromOrganization(userId: userId, orgId: orgId)),
          decodingTo: Mailgun.Users.Organization.Remove.Response.self
        )
      }
    )
  }
}

extension Mailgun.Users {
  public typealias Authenticated = Mailgun_Shared_Live.Authenticated<
    Mailgun.Users.API,
    Mailgun.Users.API.Router,
    Mailgun.Users.Client
  >
}

extension Mailgun.Users: @retroactive DependencyKey {
  public static var liveValue: Mailgun.Users.Authenticated {
    try! Mailgun.Users.Authenticated { .live(makeRequest: $0) }
  }
}

extension Mailgun.Users.API.Router: @retroactive DependencyKey {
  public static let liveValue: Mailgun.Users.API.Router = .init()
}
