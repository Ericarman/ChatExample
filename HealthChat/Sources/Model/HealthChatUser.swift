//
//  HealthUser.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 23.12.24.
//

import Foundation

public struct HealthUser: Identifiable, Equatable, Hashable, Codable, Sendable {
    public let id: String
    public let userName: String
    public let avatarURL: URL?
    public let isCurrentUser: Bool
    
    public init(id: String, userName: String, avatarURL: URL?, isCurrentUser: Bool) {
        self.id = id
        self.userName = userName
        self.avatarURL = avatarURL
        self.isCurrentUser = isCurrentUser
    }
}
