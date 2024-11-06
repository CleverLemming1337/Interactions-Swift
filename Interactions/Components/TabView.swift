//
//  File.swift
//  Interactions
//
//  Created by CleverLemming1337 on 04.11.24.
//

import Foundation

public struct TabItem: Scene {
    public let title: String
    let key: Key?
    let elements: [Renderable]
    
    public var body: some Renderable {
        elements
    }
    
    public init(key: Key? = nil, title: String, @InteractionBuilder _ content: () -> [Renderable]) {
        self.key = key
        self.title = title
        self.elements = content()
    }
}

nonisolated(unsafe) let tabKeys: [Key] = [.n1, .n2, .n3, .n4, .n5, .n6, .n7, .n8, .n9, .n0]

public struct TabView: Interaction {
    let tabs: [TabItem]
    
    @Environment(\.tabIndex) var tabIndex
    
    public var body: some Renderable {
        HStack {
            for (index, tab) in tabs.enumerated() {
                if index == tabIndex {
                    Text(" \(tab.key?.name ?? tabKeys[index].name) \(tab.title)")
                        .reversed()
                }
                else {
                    Text(" \(tab.key?.name ?? tabKeys[index].name) \(tab.title)")
                }
            }
        }
        
        tabs[tabIndex]
    }
    
    public init(tabs: [TabItem]) {
        self.tabs = tabs
        
        KeyBinder.shared.bind(with: .arrowLeft, to: { TabManager.shared.changeTabIndex(by: -1) })
        KeyBinder.shared.bind(with: .arrowRight, to: { TabManager.shared.changeTabIndex(by: 1) })
    }
}

public struct TabManager: @unchecked Sendable{
    static let shared = TabManager()
    
    let tabIndex = StateItem(0)
    
    public func changeTabIndex(by: Int) {
        tabIndex.value += by
    }
}
