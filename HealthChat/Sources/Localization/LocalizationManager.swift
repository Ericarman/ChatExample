//
//  LocalizationManager.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 25.12.24.
//

import Foundation

actor LocalizationManager {
    private static var bundle: Bundle!
    
    private(set) static var locale: Locale!
    
    private init() {}
    
    static func setLocale(_ locale: Locale) {
        Self.locale = locale
    }
    
    static func localizedBundle() -> Bundle {
        if let bundle {
            return bundle
        } else {
            let appLang = UserDefaults.standard.string(forKey: "app_lang") ?? "en"
            let path = Bundle.module.path(forResource: appLang, ofType: "lproj")
            
            bundle = if let path {
                Bundle(path: path) ?? .module
            } else { Bundle.module }
            
            return bundle
        }
    }
    
    static func setLanguage(lang: String) {
        UserDefaults.standard.set(lang, forKey: "app_lang")
        guard let path = Bundle.module.path(forResource: lang, ofType: "lproj") else {
            Logger.logDebug("Failed to get Localization path for resource: \(lang)")
            return
        }
        bundle = Bundle(path: path)
    }
}
