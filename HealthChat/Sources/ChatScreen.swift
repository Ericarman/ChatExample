//
//  ChatScreen.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import SwiftUI
import Observation
//@_implementationOnly import ExyteChat

struct ChatScreen: View {
    @EnvironmentObject private var model: HealthChatModel
    
    let onMessageSendAction: MessageSendAction
    
    var body: some View {
//        let messages = model.messages.map { m in
//            m.toMessage()
//        }
//                ChatView(messages: messages) { message in
//                    let m = HealthChatMessage(draft: message, user: model.user)
//                    onMessageSendAction(m)
//                }
        
        Button {
            let m = HealthChatMessage(
                id: UUID().uuidString,
                text: "Hello world!",
                createdAt: .now,
                sender: model.user,
                status: .sending
            )
            onMessageSendAction(m)
        } label: {
            Text("Send message")
        }
    }
}

//extension HealthChatModel {
//    var mappedMessages: [Message] {
//        messages.map { message in
//            message.toMessage()
//        }
//    }
//}

//extension User {
//    func toHealthUser() -> HealthChatUser {
//        HealthChatUser(
//            id: id,
//            name: name,
//            avatarURL: avatarURL,
//            isCurrentUser: isCurrentUser
//        )
//    }
//}

//extension HealthChatUser {
//    func toUser() -> User {
//        User(
//            id: id,
//            name: name,
//            avatarURL: avatarURL,
//            isCurrentUser: isCurrentUser
//        )
//    }
//}
//
//extension HealthChatMessage {
//    func toMessage() -> Message {
//        let s: Message.Status? = switch status {
//        case .error: Message.Status.error(.init(text: "", medias: [], recording: nil, replyMessage: nil, createdAt: creationDate))
//        case .sent: Message.Status.sent
//        case .sending: Message.Status.sending
//        case .read: Message.Status.read
//        case .none: nil
//        }
//        
//        return Message(
//            id: id,
//            user: sender.toUser(),
//            status: s,
//            createdAt: creationDate,
//            text: text,
//            attachments: [],
//            recording: nil,
//            replyMessage: nil
//        )
//    }
//    
//    init(draft: DraftMessage, user: HealthChatUser) {
//        self.init(
//            id: draft.id ?? UUID().uuidString,
//            text: draft.text,
//            createdAt: draft.createdAt,
//            sender: user,
//            status: .sending
//        )
//    }
//}

//#Preview {
//    ChatScreen(onMessageSendAction: { _ in })
//}
