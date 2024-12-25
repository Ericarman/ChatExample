//
//  BundleFinder.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 25.12.24.
//


import Foundation

#if !SWIFT_PACKAGE
extension Bundle {
    private final class BundleFinder {}
    
    static let module: Bundle = {
        let bundle = Bundle(for: BundleFinder.self)
        return bundle
    }()
}
#endif