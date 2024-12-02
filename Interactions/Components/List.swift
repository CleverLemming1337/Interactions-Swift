//
//  File.swift
//  Interactions
//
//  Created by Leonard Fekete on 02.12.24.
//

import Foundation

public struct List: Interaction, Activatable {
    let elements: [Renderable]
    @State private var selectedIndex = 0
    
    public var body: some Renderable {
        for (index, element) in elements.enumerated() {
            if index == selectedIndex {
                Text(element.render())
                    .reversed()
            }
            else if index != elements.count-1 {
                Text(element.render())
                    .underlined()
            }
            else {
                element
            }
        }
    }
    
    public init(@InteractionBuilder _ elements: () -> [Renderable]) {
        self.elements = elements()
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
