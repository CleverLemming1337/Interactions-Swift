import Foundation

public struct Slider: Interaction {
    let key: Key
    @Binding var value: Double
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
            Text(String(repeating: " ", count: Int( ((value > max ? max : value)*width/max).rounded(.down) )))
                .reversed()
                .tint()
            Text("  ")
                .reversed()
            Text(String(repeating: " ", count: Int( ((value > max ? 0 : max-value)*width/max).rounded(.up) )))
                .other("[100m", end: "[49m")
        }
    }
    
    public init(key: Key, value: Binding<Double>, in range: ClosedRange<Int> = 0...100, label: String? = nil, width: Int? = nil, step: Double = 1) {
        self.key = key
        self._value = value
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
                    if value - step >= min {
                        value -= step
                    }
                }
                else if key == .arrowRight {
                    if value + step <= max {
                        value += step
                    }
                }
                key = readKey()
            }
            AppRenderer.shared.hideCursor()
        })
    }

}
