//
//  File.swift
//  Interactions
//
//  Created by CleverLemming1337 on 02.12.24.
//

import Foundation

@propertyWrapper struct InternalState<T> {
    let id: String
    let defaultValue: T
    
    init(wrappedValue: T, id: String = "") {
        self.defaultValue = wrappedValue
        self.id = id

        // Store the binding in the storage if it doesn't exist yet
        if id != "" && StateStorage.shared.storage[id] == nil {
            StateStorage.shared.storage[id] = Binding(defaultValue)
        }
    }
    
    var wrappedValue: T {
        get {
            if let binding = StateStorage.shared.storage[id] as? Binding<T> {
                return binding.value
            }
            StateStorage.shared.storage[id] = Binding(defaultValue)
            return defaultValue
        }
        nonmutating set {
            (StateStorage.shared.storage[id] as? Binding)?.value = newValue
        }
    }
    
    var projectedValue: Binding<T> {
        if let binding = StateStorage.shared.storage[id] as? Binding<T> {
            return binding
        }
        return Binding<T>(defaultValue)
    }
}


public struct List: Interaction, Activatable {
    let elements: [Renderable]
    let key: Key
    let title: String
    @InternalState private var selectedIndex: Int
    @InternalState private var focused: Bool
    
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
                    if let _ = element as? Activatable {
                        Text("◆ ")
                            .underlined()
                    } else {
                        Text("◇ ")
                            .underlined()
                    }
                }
                Text(element.render())
                    .align(width: AppRenderer.shared.terminalSize.0 - (focused&&index==selectedIndex ? 2 : 0), alignment: .leading, padding: focused && index == selectedIndex ? 0 : 2)
                    .underlined()
            }
        }
    }
    
    public init(_ key: Key, _ title: String = "", @InteractionBuilder _ elements: () -> [Renderable], file: StaticString = #file, line: Int = #line) {
        self.key = key
        self.title = title
        self.elements = elements()

        // workaround because states of multiple lists would have the same id
        @InternalState(id: "\(file):\(line)#1") var focused = false
        @InternalState(id: "\(file):\(line)#2") var selectedIndex = 0

        self._focused = _focused
        self._selectedIndex = _selectedIndex
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
                    if let _ = element as? NavigationLink {
                        focused = false
                        return // else it would continue capturing input
                    }
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
