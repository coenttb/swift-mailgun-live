//
//  File.swift
//  swift-mailgun-live
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Foundation
import IssueReporting
@_exported import Mailgun_IPAllowlist_Types
@_exported import Mailgun_Shared_Live

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension Mailgun.IPAllowlist.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Mailgun.IPAllowlist.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Mailgun.self) var handleRequest

    return Self(
      list: {
        try await handleRequest(
          for: makeRequest(.list),
          decodingTo: Mailgun.IPAllowlist.ListResponse.self
        )
      },
      update: { request in
        try await handleRequest(
          for: makeRequest(.update(request: request)),
          decodingTo: Mailgun.IPAllowlist.SuccessResponse.self
        )
      },
      add: { request in
        try await handleRequest(
          for: makeRequest(.add(request: request)),
          decodingTo: Mailgun.IPAllowlist.SuccessResponse.self
        )
      },
      delete: { request in
        try await handleRequest(
          for: makeRequest(.delete(request: request)),
          decodingTo: Mailgun.IPAllowlist.SuccessResponse.self
        )
      }
    )
  }
}

extension Mailgun.IPAllowlist {
  public typealias Authenticated = Mailgun_Shared_Live.Authenticated<
    Mailgun.IPAllowlist.API,
    Mailgun.IPAllowlist.API.Router,
    Mailgun.IPAllowlist.Client
  >
}

extension Mailgun.IPAllowlist: @retroactive DependencyKey {
  public static var liveValue: Mailgun.IPAllowlist.Authenticated {
    try! Mailgun.IPAllowlist.Authenticated { .live(makeRequest: $0) }
  }
}

extension Mailgun.IPAllowlist.API.Router: @retroactive DependencyKey {
  public static let liveValue: Mailgun.IPAllowlist.API.Router = .init()
}
