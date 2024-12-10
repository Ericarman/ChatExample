//
//  HealthChatExampleApp.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import SwiftUI
import HealthChat

@main
struct HealthChatExampleApp: App {
    @State private var model = HealthChatModel.test
    @State private var app: HealthChatApp?
    
    var body: some Scene {
        WindowGroup {
            createApp()
        }
    }
    
    private func createApp() -> some View {
        if let app {
            return app.createView()
        } else {
            let app = HealthChatApp(chatModel: model, onConversationSelected: { conversation in
                model.messages.removeAll()
            })
            
            self.app = app
            
            return app.createView()
        }
    }
}


private extension HealthChatModel {
    static var test: HealthChatModel {
        let user = HealthChatUser(
            id: UUID().uuidString,
            name: "Bagration",
            avatarURL: nil,
            isCurrentUser: true
        )
        
        let conversations = (0...10).map { idx in
            let receiver = HealthChatUser(
                id: "preview_user\(idx)",
                name: "preview_user_name\(idx)",
                avatarURL: nil,
                isCurrentUser: false
            )
            
            return HealthChatConversation(
                id: UUID().uuidString,
                title: "Walking hour",
                imageURL: TestUtils.getAvatarURL(),
                receiverUser: receiver,
                messages: []
            )
        }
        
        return HealthChatModel(
            user: user,
            conversations: conversations,
            language: "en"
        )
    }
}
