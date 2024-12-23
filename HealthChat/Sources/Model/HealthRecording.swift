//
//  HealthRecording.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 23.12.24.
//

import Foundation

public struct HealthRecording: Codable, Hashable, Sendable {
    public var duration: Double
    public var waveformSamples: [CGFloat]
    public var url: URL?

    public init(duration: Double = 0.0, waveformSamples: [CGFloat] = [], url: URL? = nil) {
        self.duration = duration
        self.waveformSamples = waveformSamples
        self.url = url
    }
}
