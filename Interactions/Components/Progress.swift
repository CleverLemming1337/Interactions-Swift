//
//  Progress.swift
//  Interactions
//
//  Created by Leonard Fekete on 28.10.24.
//

import Foundation

public struct ProgressBar: Interaction {
    let progress: Int
    let max: Int
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: progress > max ? max : progress))
                .reversed()
                .tint()
            Text(String(repeating: " ", count: progress > max ? 0 : max-progress))
                .other("[100m", end: "[49m")
        }
    }
    
    public init(progress: Int, max: Int = 100) {
        self.progress = progress
        self.max = max
    }
}
