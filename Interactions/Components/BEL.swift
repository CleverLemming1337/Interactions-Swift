import Foundation

public func bel() {
    print("\u{07}", terminator: "")
}

public struct BEL: Renderable {
    public func render() -> String {
        return "\u{07}"
    }
    
    public init() {}
}
