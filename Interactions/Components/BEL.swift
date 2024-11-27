import Foundation

func bel() {
    print("\a")
}

public struct BEL: Renderable {
    func render() -> String {
        return "\a"
    }
}