//
//  ChatScreen.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import SwiftUI
import Observation
@_implementationOnly import ExyteChat

enum MessageError: Error {
    case failedToCreateAttachment
}

struct ChatScreen: View {
    @EnvironmentObject private var model: HealthChatModel
        
    let onMessageSendAction: MessageSendAction
    
    var body: some View {
        let messages = model.messages.map { m in
            m.toMessage()
        }
        
        ChatView(messages: messages) { message in
            Task {
                let m = await HealthChatMessage(draft: message, user: model.user)
                onMessageSendAction(m)
            }
        }
    }
}

extension User {
    func toHealthUser() -> HealthUser {
        HealthUser(
            id: id,
            userName: name,
            avatarURL: avatarURL,
            isCurrentUser: isCurrentUser
        )
    }
}

extension HealthUser {
    func toUser() -> User {
        User(
            id: id,
            name: userName,
            avatarURL: avatarURL,
            isCurrentUser: isCurrentUser
        )
    }
}

extension HealthChatMessage {
    func toMessage() -> Message {
        let s: Message.Status? = switch status {
        case .error: Message.Status.error(.init(text: "", medias: [], recording: nil, replyMessage: nil, createdAt: creationDate))
        case .sent: Message.Status.sent
        case .sending: Message.Status.sending
        case .read: Message.Status.read
        }
        
        let attachments = attachments.map { attachment in
            Attachment(from: attachment)
        }
        
        let recording: Recording? = if let recording {
            Recording(from: recording)
        } else { nil }
        
        let replyMessage: ReplyMessage? = if let replyMessage {
            ReplyMessage(from: replyMessage)
        } else { nil }

        return Message(
            id: id,
            user: sender.toUser(),
            status: s,
            createdAt: creationDate,
            text: text,
            attachments: attachments,
            recording: recording,
            replyMessage: replyMessage
        )
    }

    init(draft: DraftMessage, user: HealthUser) async {
        do {
            let attachments = try await draft.medias.asyncMap { media in
                guard let thumbnailURL = await media.getThumbnailURL(),
                      let fullURL = await media.getURL() else {
                    throw MessageError.failedToCreateAttachment
                }
                
                let type = switch media.type {
                case .image: HealthAttachmentType.image
                case .video: HealthAttachmentType.video
                }
                
                return HealthAttachment(
                    id: UUID().uuidString,
                    thumbnail: thumbnailURL,
                    full: fullURL,
                    type: type
                )
            }
            
            let recording: HealthRecording? = if let recording = draft.recording {
                HealthRecording(from: recording)
            } else { nil }
            
            let replyMessage: HealthReplyMessage? = if let reply = draft.replyMessage {
                HealthReplyMessage(from: reply)
            } else { nil }
            
            self.init(
                id: draft.id ?? UUID().uuidString,
                text: draft.text,
                createdAt: draft.createdAt,
                sender: user,
                status: .sending,
                isSender: true,
                attachments: attachments,
                recording: recording,
                replyMessage: replyMessage
            )
        } catch {
            self.init(
                id: draft.id ?? UUID().uuidString,
                text: draft.text,
                createdAt: draft.createdAt,
                sender: user,
                status: .error,
                isSender: true,
                attachments: []
            )
        }
    }
}

extension Message {
    init(from healthMessage: HealthChatMessage) {
        let s: Message.Status? = switch healthMessage.status {
        case .error: Message.Status.error(.init(text: "", medias: [], recording: nil, replyMessage: nil, createdAt: healthMessage.creationDate))
        case .sent: Message.Status.sent
        case .sending: Message.Status.sending
        case .read: Message.Status.read
        }
        
        let attachments = healthMessage.attachments.map { Attachment(from: $0) }
        
        let recording: Recording? = if let recording = healthMessage.recording {
            Recording(from: recording)
        } else { nil }
        
        let replyMessage: ReplyMessage? = if let replyMessage = healthMessage.replyMessage {
            ReplyMessage(from: replyMessage)
        } else { nil }
        
        self.init(
            id: healthMessage.id,
            user: healthMessage.sender.toUser(),
            status: s,
            createdAt: healthMessage.creationDate,
            text: healthMessage.text,
            attachments: attachments,
            recording: recording,
            replyMessage: replyMessage
        )
    }
}

extension Attachment {
    init(from healthAttachment: HealthAttachment) {
        self.init(
            id: healthAttachment.id,
            thumbnail: healthAttachment.thumbnail,
            full: healthAttachment.full,
            type: AttachmentType(from: healthAttachment.type)
        )
    }
}

extension Recording {
    init(from healthRecording: HealthRecording) {
        self.init(
            duration: healthRecording.duration,
            waveformSamples: healthRecording.waveformSamples,
            url: healthRecording.url
        )
    }
}

extension ReplyMessage {
    init(from healthReplyMessage: HealthReplyMessage) {
        let recording: Recording? = if let recording = healthReplyMessage.recording {
            Recording(from: recording)
        } else { nil }
        
        let attachments = healthReplyMessage.attachments.map { attachment in
            Attachment(from: attachment)
        }
        
        self.init(
            id: healthReplyMessage.id,
            user: healthReplyMessage.user.toUser(),
            createdAt: healthReplyMessage.createdAt,
            text: healthReplyMessage.text,
            attachments: attachments,
            recording: recording
        )
    }
}

extension AttachmentType {
    init(from type: HealthAttachmentType) {
        switch type {
        case .image:
            self = .image
        case .video:
            self = .video
        }
    }
}

extension HealthRecording {
    init(from recording: Recording) {
        self.init(
            duration: recording.duration,
            waveformSamples: recording.waveformSamples,
            url: recording.url
        )
    }
}

extension HealthReplyMessage {
    init(from reply: ReplyMessage) {
        let attachments = reply.attachments.map {
            HealthAttachment(from: $0)
        }
        
        let recording: HealthRecording? = if let recording = reply.recording {
            HealthRecording(from: recording)
        } else { nil }
        
        self.init(
            id: reply.id,
            user: reply.user.toHealthUser(),
            createdAt: reply.createdAt,
            text: reply.text,
            attachments: attachments,
            recording: recording
        )
    }
}

extension HealthAttachment {
    init(from attachment: Attachment) {
        self.init(
            id: attachment.id,
            thumbnail: attachment.thumbnail,
            full: attachment.full,
            type: HealthAttachmentType(from: attachment.type)
        )
    }
}

extension HealthAttachmentType {
    init(from type: AttachmentType) {
        switch type {
        case .image:
            self = .image
        case .video:
            self = .video
        }
    }
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
