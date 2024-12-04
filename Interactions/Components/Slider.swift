import Foundation

public struct Slider: Interaction, Activatable {
    let key: Key?
    @Binding var value: Int
    // use Double for divisions
    let max: Double
    let min: Double
    let label: String?
    let width: Double
    let step: Int
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            if label != nil {
                Text(label! + " ")
            }
            if let key = key {
                Text(key.name)
                    .padding()
                    .other("[100m", end: "[49m")
            }
            Text(String(repeating: " ", count: Int((Double(value) > max ? max : Double(value)) * width / max)))
                .reversed()
                .tint()
            Text("  ")
                .reversed()
            Text(String(repeating: " ", count: Int( ((Double(value) > max ? 0 : max-Double(value))*width/max).rounded(.up) )))
                .other("[100m", end: "[49m")
        }
    }
    
    public init(key: Key? = nil, value: Binding<Int>, in range: ClosedRange<Int> = 0...100, label: String? = nil, width: Int? = nil, step: Int = 1) {
        self.key = key
        self._value = value
        self.min = Double(range.lowerBound)
        self.max = Double(range.upperBound)
        self.label = label
        self.step = step
        
        var calculatedWidth = (width ?? Int(AppRenderer.shared.terminalSize.0)) - 2 // 2 for middle
        
        if let key = key {
            calculatedWidth -= 2 // 2 for shortcut padding
            calculatedWidth -= key.name.count
        } else { // means that is in a list
            calculatedWidth -= 4
        }
        
        if label != nil {
            calculatedWidth -= label!.count + 2
        }
        self.width = Double(calculatedWidth)

        if key != nil {
            bindActivation(with: key!)
        }
    }
    
    public func activate() {
        AppRenderer.shared.showCursor()
        var key = readKey()
        while key != .newLine && key != .escape {
            if key == .arrowLeft {
                if value - step >= Int(min) {
                    value -= step
                }
            }
            else if key == .arrowRight {
                if value + step <= Int(max) {
                    value += step
                }
            }
            key = readKey()
        }
        AppRenderer.shared.hideCursor()
    }
}
