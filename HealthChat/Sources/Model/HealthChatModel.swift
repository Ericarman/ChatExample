//
//  HealthChatConfig.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import Foundation
import SwiftUI
import Combine

@MainActor
public final class HealthChatModel: ObservableObject {
    @Published
    public var user: HealthUser
    @Published
    public var messages: [HealthChatMessage] = []
    @Published
    public var expirationDate: Date
    
    public let language: String
    
    public init(
        user: HealthUser,
        expirationDate: Date,
        language: String
    ) {
        self.user = user
        self.expirationDate = expirationDate
        self.language = language
    }
}

public typealias MessageSendAction = (HealthChatMessage) -> Void

@MainActor
public final class HealthChatApp {
    let chatModel: HealthChatModel
    let onMessageSendAction: MessageSendAction
    
    public init(
        chatModel: HealthChatModel,
        onMessageSendAction: @escaping MessageSendAction
    ) {
        self.chatModel = chatModel
        self.onMessageSendAction = onMessageSendAction
    }
    
    public func createViewController() -> some UIViewController {
        UIHostingController(rootView: createView())
    }
    
    public func createView() -> some View {
        return ChatScreen { [weak self] message in
            self?.onMessageSendAction(message)
        }
        .preferredColorScheme(.light)
        .environmentObject(chatModel)
    }
}
