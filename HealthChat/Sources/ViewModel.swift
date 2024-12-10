//
//  ViewModel.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import Foundation

@MainActor
protocol ViewModel: Identifiable, Hashable, Equatable {}

extension ViewModel {
    nonisolated var id: String { String(describing: self) }
}

extension ViewModel {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    nonisolated static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
