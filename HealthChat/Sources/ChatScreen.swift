//
//  ChatScreen.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import SwiftUI
@_implementationOnly import ExyteChat

enum MessageError: Error {
    case failedToCreateAttachment
}

enum CustomMessageMenuAction: MessageMenuAction {
    case reply
    
    func title() -> String {
        "reply".localized()
    }
    
    func icon() -> Image {
        Image(systemName: "arrowshape.turn.up.left")
    }
}

struct ChatScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: HealthChatModel
    
    let onMessageSendAction: MessageSendAction
    let onMessageEditAction: MessageSendAction
    
    var availableInputType: AvailableInputType {
        switch model.status {
        case .active:
            return .full
        case .inactive:
            return .none
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            let messages = model.messages.map { m in
                m.toMessage()
            }
            
            ChatView<EmptyView, EmptyView, CustomMessageMenuAction>(messages: messages, chatType: .conversation, replyMode: .answer) { message in
                Task {
                    let m = await HealthChatMessage(draft: message, user: model.user)
                    onMessageSendAction(m)
                }
            } messageMenuAction: {
                selectedMenuAction,
                defaultActionClosure,
                message in
                switch selectedMenuAction {
                case .reply:
                    defaultActionClosure(message, .reply)
                }
            }
            .setAvailableInput(availableInputType)
            .setMediaPickerSelectionParameters(
                .init(
                    mediaType: .photo,
                    selectionStyle: .checkmark,
                    selectionLimit: nil,
                    showFullscreenPreview: true
                )
            )
            .mediaPickerTheme(
                main: .init(
                    text: .black,
                    albumSelectionBackground: .black,
                    fullscreenPhotoBackground: .black,
                    cameraBackground: .black,
                    cameraSelectionBackground: .black
                )
            )
        }
    }
}

extension User {
    func toHealthUser() -> HealthUser {
        HealthUser(
            id: id,
            userName: name,
            avatarURL: avatarURL,
            userDescription: nil,
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
    init(from message: Message) {
        let attachments = message.attachments.map {
            HealthAttachment(from: $0)
        }
        
        let recording: HealthRecording? = if let recording = message.recording {
            HealthRecording(from: recording)
        } else { nil }
        
        let replyMessage: HealthReplyMessage? = if let reply = message.replyMessage {
            HealthReplyMessage(from: reply)
        } else { nil }
        
        self.init(
            id: message.id,
            text: message.text,
            createdAt: message.createdAt,
            sender: message.user.toHealthUser(),
            status: HealthChatMessage.Status(from: message.status ?? .sending),
            attachments: attachments,
            recording: recording,
            replyMessage: replyMessage
        )
    }
    
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

extension HealthChatMessage.Status {
    init(from status: Message.Status) {
        switch status {
        case .sending:
            self = .sending
        case .sent:
            self = .sent
        case .read:
            self = .read
        case .error:
            self = .error
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
