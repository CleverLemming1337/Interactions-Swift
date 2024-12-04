import Foundation

public struct Slider_: Interaction {
    let label: String?
    let min: Int
    let max: Int
    let steps: Int
    let value: StateItem<Int>
    let key: Key
    let width: Int
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            if label != nil {
                Text(label!+" ")
            }
            Text("\(key.name)")
                .padding(1)
                .other("[100m", end: "[49m")
            Text(String(repeating: " ", count: (min + (width/max) * value.value)))
                .other("[100m", end: "[49m")
            Text("  ")
                .reversed()
            Text(String(repeating: " ", count: 1))
                .reversed()
                .tint()
        }
    }

    public init(key: Key, min: Int = 0, max: Int = 255, steps: Int = 1, value: StateItem<Int>, width: Int? = nil, label: String? = nil) {
        self.label = label
        self.min = min
        self.max = max
        self.steps = steps
        self.value = value
        self.key = key
        self.width = (width ?? Int(AppRenderer.shared.terminalSize.0)) - key.name.count - 2 - (label != nil ? label!.count + 1 : 0) - 2
        
        KeyBinder.shared.bind(with: key, to: {
            var key = readKey()
            while key != .newLine {
                if key == .arrowLeft {
                    if value.value > min {
                        value.value -= 1
                    }
                }
                else if key == .arrowRight {
                    if value.value < max {
                        value.value += 1
                    }
                }
                key = readKey()
            }
        })
    }
}

public struct Slider: Interaction {
    let key: Key
    let value: StateItem<Double>
    let max: Double
    let min: Double
    let label: String?
    let width: Double
    let step: Double
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            if label != nil {
                Text(label!+" ")
            }
            Text(key.name)
                .padding()
                .other("[100m", end: "[49m")
            Text(String(repeating: " ", count: Int( ((value.value > max ? max : value.value)*width/max).rounded(.down) )))
                .reversed()
                .tint()
            Text("  ")
                .reversed()
            Text(String(repeating: " ", count: Int( ((value.value > max ? 0 : max-value.value)*width/max).rounded(.up) )))
                .other("[100m", end: "[49m")
        }
    }
    
    public init(key: Key, value: StateItem<Double>, in range: ClosedRange<Int> = 0...100, label: String? = nil, width: Int? = nil, step: Double = 1) {
        self.key = key
        self.value = value
        self.min = Double(range.lowerBound)
        self.max = Double(range.upperBound)
        self.label = label
        self.step = step
        
        var calculatedWidth = Double(width ?? Int(AppRenderer.shared.terminalSize.0)) - 4 /* 2 for middle, 2 for shortcut padding */ - Double(key.name.count)
        
        if label != nil {
            calculatedWidth -= Double(label!.count + 2)
        }
        self.width = calculatedWidth
        
        bind()
    }
    
    func bind() {
        KeyBinder.shared.bind(with: key, to: { [self] in
            AppRenderer.shared.showCursor()
            var key = readKey()
            while key != .newLine && key != .escape {
                if key == .arrowLeft {
                    if value.value - step >= min {
                        value.value -= step
                    }
                }
                else if key == .arrowRight {
                    if value.value + step <= max {
                        value.value += step
                    }
                }
                key = readKey()
            }
            AppRenderer.shared.hideCursor()
        })
    }

}
