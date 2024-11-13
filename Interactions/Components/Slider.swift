import Foundation

public struct Slider: Interaction {
    let min: Int
    let max: Int
    let steps: Int
    let value: StateItem<Int>

    public var body: some Renderable {
        Text("\(value.value)")
    }

    public init(key: Key, min: Int = 0, max: Int = 255, steps: Int = 1, value: StateItem<Int>) {
        self.min = min
        self.max = max
        self.steps = steps
        self.value = value
        
        KeyBinder.shared.bind(with: key, to: {
            value.value += 1
        })
    }
}