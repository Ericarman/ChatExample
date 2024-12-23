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
    @StateObject private var model = HealthChatModel.test
    @State private var app: HealthChatApp?
    
    var body: some Scene {
        WindowGroup {
            createApp()
        }
    }
    
    private func createApp() -> some View {
        if let app {
            return rootView(app: app)
        } else {
            let app = HealthChatApp(
                chatModel: model,
                onMessageSendAction: { message in
                    sendMessage(message)
                }
            )
            
            self.app = app
            
            return rootView(app: app)
        }
    }
    
    private func rootView(app: HealthChatApp) -> some View {
        NavigationView {
            app.createView()
        }
    }
    
    private func sendMessage(_ message: HealthChatMessage) {
        model.messages.append(message)
        
        Task {
            do {
                try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
                
                if let idx = getMessageIdx(message) {
                    model.messages[idx].status = .sent
                }
            } catch {
                if let idx = getMessageIdx(message) {
                    model.messages[idx].status = .error
                }
                
                // TODO: Maybe show some toasts
            }
            
            print(model.messages)
        }
    }
    
    private func getMessageIdx(_ message: HealthChatMessage) -> Int? {
        model.messages.firstIndex(where: { $0.id == message.id })
    }
}


private extension HealthChatModel {
    static var test: HealthChatModel {
        let user = HealthUser(
            id: UUID().uuidString,
            userName: "Bagration",
            avatarURL: nil,
            userDescription: "Wigmore Clinic",
            isCurrentUser: true
        )
        
        let expirationDate = Date.now.addingTimeInterval(60 * 60 * 24 * 7)
        
        return HealthChatModel(
            user: user, expirationDate: expirationDate, language: "en"
        )
    }
}
