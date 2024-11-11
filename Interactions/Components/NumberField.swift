public struct NumberField: Interaction, Formattable {
    let key: Key
    let label: String
    let showShortcut: Bool
    let number: StateItem<Int>
    
    @Environment(\.renderer) var renderer
    
    public func focus() {
        let allowedKeys: [Key] = [.n1, .n2, .n3, .n4, .n5, .n6, .n7, .n8, .n9, .n0]
        renderer.showCursor()
        var pressedKey = Key.null
        while pressedKey != .newLine {
            pressedKey = readKey()
            if pressedKey == .backspace {
                number.value /= 10
            }
            else if allowedKeys.contains(pressedKey) {
                number.value = number.value * 10 + Int(pressedKey.string)!
            }
        }
        renderer.hideCursor()
    }
    
    public init(_ key: Key, _ label: String, number: StateItem<Int>, showShortcut: Bool = true) {
        self.key = key
        self.label = label
        self.showShortcut = showShortcut
        self.number = number
        
        @Environment(\.keyBinder) var keyBinder
        
        keyBinder.bind(with: key, to: focus)
    }
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            Text(label)
                .padding()
                .reversed()
            if showShortcut {
                Text(key.name)
                    .padding()
                    .other("[100m", end: "[49m")
            }
            Text("\(number.value)")
                    .padding()
                    .reversed()
                    .tint()
        }
    }
}