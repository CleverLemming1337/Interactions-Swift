//
//  Progress.swift
//  Interactions
//
//  Created by Leonard Fekete on 28.10.24.
//

import Foundation

public struct ProgressBar: Interaction {
    let progress: Double
    let max: Double
    let width: Double
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: Int( ((progress > max ? max : progress)*width/max).rounded(.down) )))
                .reversed()
                .tint()
            Text(String(repeating: " ", count: Int( ((progress > max ? 0 : max-progress)*width/max).rounded(.up) )))
                .other("[100m", end: "[49m")
        }
    }
    
    public init(progress: Int, max: Int = 100, width: Int? = nil) {
        self.progress = Double(progress)
        self.max = Double(max)
        self.width = Double(width ?? Int(AppRenderer.shared.terminalSize.0))
    }
}
