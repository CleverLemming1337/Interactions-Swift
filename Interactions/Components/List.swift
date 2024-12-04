//
//  File.swift
//  Interactions
//
//  Created by Leonard Fekete on 02.12.24.
//

import Foundation

public struct List: Interaction, Activatable {
    let elements: [Renderable]
    let key: Key
    let title: String
    @State private var selectedIndex = 0
    @State private var focused = false
    
    public var body: some Renderable {
        HStack {
            Text(key.name)
                .padding()
                .other("[100m", end: "[49m")
            Text(title)
        }
        for (index, element) in elements.enumerated() {
            HStack(spacing: 0) {
                if focused && index == selectedIndex {
                    Text("◆ ")
                    .underlined()
                }
                Text(element.render())
                    .align(width: AppRenderer.shared.terminalSize.0 - (focused&&index==selectedIndex ? 2 : 0), alignment: .leading, padding: focused && index == selectedIndex ? 0 : 2)
                    .underlined()
            }
        }
    }
    
    public init(_ key: Key, _ title: String = "", @InteractionBuilder _ elements: () -> [Renderable]) {
        self.key = key
        self.title = title
        self.elements = elements()

        bindActivation(with: key)
    }
    
    public func activate() {
        focused = true
        var key = readKey()
        
        while key != .escape {
            if key == .arrowUp && selectedIndex > 0 {
                selectedIndex -= 1
            }
            else if key == .arrowDown && selectedIndex < elements.count-1 {
                selectedIndex += 1
            }
            else if key == .newLine {
                if let element = elements[selectedIndex] as? Activatable {
                    element.activate()
                }
                else {
                    bel()
                }
            }
            key = readKey()
        }
        focused = false
    }
}
