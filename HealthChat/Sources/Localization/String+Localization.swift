//
//  String+Localization.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 25.12.24.
//

import Foundation

extension String {
    func localized(tableName: String? = nil) -> String {
        String(
            localized: LocalizationValue(self),
            table: tableName,
            bundle: LocalizationManager.localizedBundle()
        )
    }
    
    func localizeWithFormat(arguments: CVarArg...) -> String {
        String(format: self.localized(), arguments: arguments)
    }
}
