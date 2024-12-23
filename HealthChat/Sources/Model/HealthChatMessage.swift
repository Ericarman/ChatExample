//
//  HealthChatMessage.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 23.12.24.
//

import Foundation

public struct HealthChatMessage: Identifiable, Sendable {
    public enum Status: Equatable, Hashable, Sendable {
        case sending
        case sent
        case read
        case error
    }
    
    public var id: String
    public var text: String
    public var creationDate: Date
    public var sender: HealthUser
    public var status: Status
    public var isSender: Bool
    public var attachments: [HealthAttachment]
    public var recording: HealthRecording?
    public var replyMessage: HealthReplyMessage?
        
    public init(
        id: String,
        text: String,
        createdAt creationDate: Date,
        sender: HealthUser,
        status: Status,
        isSender: Bool,
        attachments: [HealthAttachment],
        recording: HealthRecording? = nil,
        replyMessage: HealthReplyMessage? = nil
    ) {
        self.id = id
        self.text = text
        self.creationDate = creationDate
        self.sender = sender
        self.status = status
        self.isSender = isSender
        self.attachments = attachments
        self.recording = recording
        self.replyMessage = replyMessage
    }
}
