//
//  DateMapper.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 23.12.24.
//

import Foundation

extension Date {
    func formattedDifference(to endDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour], from: self, to: endDate)
        
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        
        return "\(days)օր, \(hours)ժ"
    }
}
