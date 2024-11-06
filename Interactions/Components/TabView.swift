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

public struct TabView: Interaction {
    let tabs: [TabItem]
    
    @Environment(\.tabIndex) var tabIndex
    
    public var body: some Renderable {
        HStack {
            for (index, tab) in tabs.enumerated() {
                if index == tabIndex {
                    Text("\(tab.title)")
                        .reversed()
                }
                else {
                    Text("\(tab.title)")
                }
            }
        }
        
        tabs[tabIndex]
    }
    
    public init(tabs: [TabItem]) {
        self.tabs = tabs
        
        KeyBinder.shared.bind(with: .arrowLeft, to: { TabManager.shared.changeTabIndex(by: -1, max: tabs.count-1) })
        KeyBinder.shared.bind(with: .arrowRight, to: { TabManager.shared.changeTabIndex(by: 1, max: tabs.count-1) })
    }
}

public class TabManager: @unchecked Sendable {
    static let shared = TabManager()
    
    var tabIndex: Int = 0
    
    public func changeTabIndex(by: Int, max: Int = -1) {
        setTabIndex(to: tabIndex+by, max: max)
    }
    
    public func setTabIndex(to index: Int, max: Int = -1) {
        if index < 0 {
            tabIndex = 0
        }
        else if max > 0 && index > max {
            tabIndex = max
        }
        else {
            tabIndex = index
        }
        AppRenderer.shared.renderApp()
    }
}
