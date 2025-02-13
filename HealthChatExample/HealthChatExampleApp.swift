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
//            ContactUsScreen()
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
        }
    }
    
    private func getMessageIdx(_ message: HealthChatMessage) -> Int? {
        model.messages.firstIndex(where: { $0.id == message.id })
    }
}

private extension HealthChatModel {
    static var test: HealthChatModel {
        let user = HealthUser.test
        
        
        let model = HealthChatModel(
            user: user, status: .inactive, language: "en"
        )
        model.messages = HealthChatMessage.testMessagesList
        return model
    }
}

private extension HealthUser {
    static var test: HealthUser {
        HealthUser(
            id: UUID().uuidString,
            userName: "Զավեն Քոլոյան",
            avatarURL: TestUtils.getAvatarURL(),
            isCurrentUser: true
        )
    }
}

private extension HealthChatMessage {
    static var testMessagesList: [HealthChatMessage] {
        (1...50).map { _ in
            HealthChatMessage(
                id: UUID().uuidString,
                text: UUID().uuidString,
                createdAt: .now,
                sender: HealthUser.test,
                status: .sent,
                attachments: [.init(id: UUID().uuidString, thumbnail: URL(string: "https://www.google.com/imgres?q=%D5%8D%D5%A1%D5%B4%D5%BE%D5%A5%D5%AC%20%D5%80%D5%A1%D5%B5%D6%80%D5%A1%D5%BA%D5%A5%D5%BF%D5%B5%D5%A1%D5%B6%20linkedin&imgurl=https%3A%2F%2Fmedia.licdn.com%2Fdms%2Fimage%2Fv2%2FD4E03AQE6zb8vjmsvAg%2Fprofile-displayphoto-shrink_200_200%2Fprofile-displayphoto-shrink_200_200%2F0%2F1703945913671%3Fe%3D2147483647%26v%3Dbeta%26t%3DwY2chxAKzdhQsohEmc2ljKzE8oH53om9OKbgmTZAGa4&imgrefurl=https%3A%2F%2Fam.linkedin.com%2Fin%2Fhayrapetyansami&docid=0y0FTC5rfqWHrM&tbnid=TjSnleW8P-4y8M&vet=12ahUKEwinwqXjusCLAxW6Q_EDHU0bCFIQM3oECBwQAA..i&w=200&h=200&hcb=2&ved=2ahUKEwinwqXjusCLAxW6Q_EDHU0bCFIQM3oECBwQAA")!,
                                    full: URL(string: "https://www.google.com/imgres?q=%D5%8D%D5%A1%D5%B4%D5%BE%D5%A5%D5%AC%20%D5%80%D5%A1%D5%B5%D6%80%D5%A1%D5%BA%D5%A5%D5%BF%D5%B5%D5%A1%D5%B6%20linkedin&imgurl=https%3A%2F%2Fmedia.licdn.com%2Fdms%2Fimage%2Fv2%2FD4E03AQE6zb8vjmsvAg%2Fprofile-displayphoto-shrink_200_200%2Fprofile-displayphoto-shrink_200_200%2F0%2F1703945913671%3Fe%3D2147483647%26v%3Dbeta%26t%3DwY2chxAKzdhQsohEmc2ljKzE8oH53om9OKbgmTZAGa4&imgrefurl=https%3A%2F%2Fam.linkedin.com%2Fin%2Fhayrapetyansami&docid=0y0FTC5rfqWHrM&tbnid=TjSnleW8P-4y8M&vet=12ahUKEwinwqXjusCLAxW6Q_EDHU0bCFIQM3oECBwQAA..i&w=200&h=200&hcb=2&ved=2ahUKEwinwqXjusCLAxW6Q_EDHU0bCFIQM3oECBwQAA")!, type: .image)],
                recording: HealthRecording(duration: 2, waveformSamples: [], url: nil)
            )
        }
    }
}
