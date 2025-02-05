//
//  ContactUsScreen.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 04.02.25.
//

import SwiftUI

public struct ContactUsScreen: View {
    private static let phoneNumber = "+374 96 155 315"
    
    @Environment(\.openURL) private var openURL
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            dragIndicator
            VStack(alignment: .leading, spacing: 32) {
                headerSection
                contactSection
            }
            .padding(16)
        }
    }
    
    private var dragIndicator: some View {
        Capsule()
            .fill(DSColor.darkBackground)
            .frame(width: 36, height: 5)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("contact_us".localized())
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(DSColor.primaryText)
                .lineLimit(1)
            
            Text("for_questions_contact_message".localized())
                .font(.subheadline)
                .foregroundStyle(DSColor.secondaryText)
        }
    }
    
    private var contactSection: some View {
        HStack(spacing: 16) {
            Text(Self.phoneNumber)
                .foregroundStyle(DSColor.secondaryText)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                handlePhoneNumberTap()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .foregroundStyle(.white)
                    
                    Text("call".localized())
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(DSColor.brandBackground, in: .capsule)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(DSColor.tertiaryBorder, lineWidth: 1)
        }
    }
    
    // MARK: Functional
    
    private func handlePhoneNumberTap() {
        guard let url = URL(string: "tel://\(Self.phoneNumber)") else { return }
        
        openURL(url)
    }
}

#Preview {
    if #available(iOS 16, *) {
        NavigationView {
            VStack {
                
            }.sheet(isPresented: .constant(true)) {
                VStack(spacing: 0) {
                    ContactUsScreen()
                    Spacer()
                }
            }
        }
    }
}
