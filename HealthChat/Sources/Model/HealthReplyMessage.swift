//
//  HealthReplyMessage.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 23.12.24.
//

import Foundation

public struct HealthReplyMessage: Codable, Identifiable, Hashable, Sendable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.user == rhs.user &&
        lhs.createdAt == rhs.createdAt &&
        lhs.text == rhs.text &&
        lhs.attachments == rhs.attachments &&
        lhs.recording == rhs.recording
    }

    public var id: String
    public var user: HealthUser
    public var createdAt: Date

    public var text: String
    public var attachments: [HealthAttachment]
    public var recording: HealthRecording?

    public init(id: String,
                user: HealthUser,
                createdAt: Date,
                text: String = "",
                attachments: [HealthAttachment] = [],
                recording: HealthRecording? = nil) {

        self.id = id
        self.user = user
        self.createdAt = createdAt
        self.text = text
        self.attachments = attachments
        self.recording = recording
    }

    func toMessage() -> HealthChatMessage {
        HealthChatMessage(
            id: id,
            text: text,
            createdAt: createdAt,
            sender: user,
            status: .sending,
            attachments: attachments
        )
    }
}
