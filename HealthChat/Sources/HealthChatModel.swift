//
//  HealthChatConfig.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import Foundation
import SwiftUI
internal import ExyteChat

@Observable
@MainActor
public final class HealthChatModel {
    public var user: HealthChatUser
    public var messages: [HealthChatMessage] = []
    public var conversations: [HealthChatConversation] = []
    
    public let language: String
    
    public init(
        user: HealthChatUser,
        conversations: [HealthChatConversation],
        language: String
    ) {
        self.user = user
        self.conversations = conversations
        self.language = language
    }
    
    func handleSendMessage(_ message: DraftMessage) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let healthMessage = HealthChatMessage(
                    id: message.id ?? UUID().uuidString,
                    text: message.text,
                    createdAt: message.createdAt,
                    sender: TestUtils.senderUser.toHealthUser(),
                    status: .sending
                )
                
                try await send(message: healthMessage)
            } catch {
                // TODO:
            }
        }
    }
    
    func send(message: HealthChatMessage) async throws {
        messages.append(message)
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                try await Task.sleep(for: .seconds(2))
                
                if let idx = getMessageIdx(message) {
                    messages[idx].status = .sent
                }
            } catch {
                if let idx = getMessageIdx(message) {
                    messages[idx].status = .error
                }
                
                // TODO: Maybe show some toasts
            }
        }
    }
    
    private func getMessageIdx(_ message: HealthChatMessage) -> Int? {
        messages.firstIndex(where: { $0.id == message.id })
    }
}

public struct HealthChatUser: Identifiable {
    public let id: String
    public let name: String
    public let avatarURL: URL?
    public let isCurrentUser: Bool
    
    public init(id: String, name: String, avatarURL: URL?, isCurrentUser: Bool) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.isCurrentUser = isCurrentUser
    }
}

public struct HealthChatConversation: Identifiable {
    public let id: String
    public let title: String
    public let imageURL: URL
    public let receiverUser: HealthChatUser
    public let messages: [HealthChatMessage]
    
    public init(id: String, title: String, imageURL: URL, receiverUser: HealthChatUser, messages: [HealthChatMessage]) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.receiverUser = receiverUser
        self.messages = messages
    }
}

public struct HealthChatMessage: Identifiable {
    public enum Status: Equatable, Hashable {
        case sending
        case sent
        case read
        case error
    }
    
    public var id: String
    public var text: String
    public var creationDate: Date
    public var sender: HealthChatUser
    public var status: Status?
    
    public init(id: String, text: String, createdAt date: Date, sender: HealthChatUser, status: Status?) {
        self.id = id
        self.text = text
        self.creationDate = date
        self.sender = sender
        self.status = status
    }
}

public typealias ConversationSelection = (HealthChatConversation) -> Void

@MainActor
public final class HealthChatApp {
    let chatModel: HealthChatModel
    let onConversationSelected: ConversationSelection
    
    public init(chatModel: HealthChatModel, onConversationSelected: @escaping ConversationSelection) {
        self.chatModel = chatModel
        self.onConversationSelected = onConversationSelected
    }
    
    public func createViewController() -> some UIViewController {
        UIHostingController(rootView: createView())
    }
    
    public func createView() -> some View {
        let vm = ConversationsViewModel(user: chatModel.user,
                                        onConversationSelected: { [weak self] conversation in
            self?.onConversationSelected(conversation)
        })
        return ConversationsScreen(viewModel: vm)
            .environment(chatModel)
    }
}
