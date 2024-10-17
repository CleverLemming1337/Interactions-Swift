//
//  Overlay.swift
//  Interactions
//
//  Created by Leonard on 17.10.24.
//

import Foundation

public struct Overlay: AbsolutePosition {
    public let x: UInt16
    public let y: UInt16
    let content: any Renderable
    
    public var body: some Renderable {
        content
    }
    
    public init(x: UInt16, y: UInt16, @InteractionBuilder _ content: () -> some Renderable) {
        self.x = x
        self.y = y
        self.content = content()
    }
}
