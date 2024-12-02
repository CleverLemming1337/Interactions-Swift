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
    @State private var selectedIndex = 0
    
    public var body: some Renderable {
        Text(selectedIndex.description)
        for (index, element) in elements.enumerated() {
            if index == selectedIndex {
                if index != elements.count-1 {
                    Text(element.render())
                    .reversed()
                        .align(width: AppRenderer.shared.terminalSize.0, alignment: .leading, padding: 1)
                        .underlined()
                }
                else {
                    Text(element.render())
                        .reversed()
                        .align(width: AppRenderer.shared.terminalSize.0, alignment: .leading, padding: 1)
                }
            }
            else if index != elements.count-1 {
                Text(element.render())
                    .align(width: AppRenderer.shared.terminalSize.0, alignment: .leading, padding: 1)
                    .underlined()
            }
            else {
                Text(element.render())
                    .align(width: AppRenderer.shared.terminalSize.0, alignment: .leading, padding: 1)
            }
        }
    }
    
    public init(_ key: Key, @InteractionBuilder _ elements: () -> [Renderable]) {
        self.key = key
        self.elements = elements()

        bindActivation(with: key)
    }
    
    public func activate() {
        AppRenderer.shared.showCursor()
        
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
    }
}
