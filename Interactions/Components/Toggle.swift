//
//  File.swift
//  Interactions
//
//  Created by CleverLemming1337 on 31.10.24.
//

import Foundation

public struct Toggle: Interaction {
    let label: String?
    let key: Key
    let isOn: StateItem<Bool>
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            if label != nil {
                Text(label!+" ")
            }
            if isOn.value {
                Text("\(centered: key.name, width: 5)")
                    .background(.green)
            }
            Text("  ")
                .reversed()
            if !isOn.value {
                Text("\(centered: key.name, width: 5)")
                    .other("[100m", end: "[49m")
            }
        }
    }
    
    public init(label: String? = nil, key: Key, isOn: StateItem<Bool>) {
        self.label = label
        self.key = key
        self.isOn = isOn
        
        KeyBinder.shared.bind(with: key, to: { isOn.value.toggle() })
    }
}
