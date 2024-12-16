//
//  ChatList.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import SwiftUI
import Combine
//@_implementationOnly import ExyteChat

final class ConversationsViewModel: ViewModel, ObservableObject {
    let user: HealthChatUser
    @Published
    var navigationPath: ConversationDestination?
    
    let onConversationSelected: ConversationSelection
    
    init(
        user: HealthChatUser,
        onConversationSelected: @escaping ConversationSelection
    ) {
        self.user = user
        self.onConversationSelected = onConversationSelected
    }
    
    func handleConversationTap(_ conversation: HealthChatConversation) {
        onConversationSelected(conversation)
        navigationPath = .chat
    }
}

enum ConversationDestination: Hashable {
    case chat
}

struct ConversationsScreen: View {
    @EnvironmentObject private var model: HealthChatModel
    @ObservedObject private(set) var viewModel: ConversationsViewModel
    
    let onMessageSendAction: MessageSendAction
    
    var body: some View {
        NavigationView {
            List(model.conversations) { conversation in
                ConversationCell(
                    title: conversation.title,
                    subtitle: "Here should be the last message description",
                    imageURL: URL(string: TestUtils.defaultImage)!
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .onTapGesture {
                    viewModel.handleConversationTap(conversation)
                }
            }
            .background {
                NavigationLink(
                    tag: ConversationDestination.chat,
                    selection: $viewModel.navigationPath,
                    destination: {
                        ChatScreen(onMessageSendAction: onMessageSendAction)
                    },
                    label: {
                        EmptyView()
                    }
                )
            }
        }
    }
}

private struct ConversationCell: View {
    let title: String
    let subtitle: String
    let imageURL: URL
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AsyncImage(url: imageURL)
                .scaledToFill()
                .clipped()
                .frame(width: 80, height: 80)
                .clipShape(.capsule)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.subheadline)
                    .lineLimit(1)
            }
        }
    }
}

//#Preview {
//    let sender = HealthChatUser(
//        id: TestUtils.senderUser.id,
//        name: TestUtils.senderUser.name,
//        avatarURL: TestUtils.senderUser.avatarURL,
//        isCurrentUser: true
//    )
//    
//    let vm = ConversationsViewModel(user: sender, onConversationSelected: { _ in })
//    ConversationsScreen(viewModel: vm, onMessageSendAction: { _ in })
//}
