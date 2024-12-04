import Foundation

#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#else
#error("Unknown OS")
#endif

public func bel() {
    print("\u{07}", terminator: "")
    #if os(macOS) // not working on Linux
    fflush(stdout)
    #endif
}

public struct BEL: Renderable {
    public func render() -> String {
        return "\u{07}"
    }
    
    public init() {}
}
