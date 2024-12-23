//
//  HealthAttachment.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 23.12.24.
//

import Foundation

public struct HealthAttachment: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let thumbnail: URL
    public let full: URL
    public let type: HealthAttachmentType

    public init(id: String, thumbnail: URL, full: URL, type: HealthAttachmentType) {
        self.id = id
        self.thumbnail = thumbnail
        self.full = full
        self.type = type
    }

    public init(id: String, url: URL, type: HealthAttachmentType) {
        self.init(id: id, thumbnail: url, full: url, type: type)
    }
}

public enum HealthAttachmentType: Codable, Sendable {
    case image, video
}
