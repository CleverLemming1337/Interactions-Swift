//
//  SwiftLogo.swift
//  Interactions
//
//  Created by Leonard on 18.10.24.
//

import Foundation

public struct SwiftLogo: Interaction, Formattable {
    public var body: some Renderable {
        VStack(spacing: 0) {
            Text("         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            Text("       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            Text("      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            Text("    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            Text("   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX")
            Text("   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXX")
            Text("   XXXXXXXXXXXXXX  XXXXXXXXXXXXXXXX    XXXXXXXXXXXXXXXX")
            Text("   XXXXXXXXX  XXXX    XXXXXXXXXXXXXX     XXXXXXXXXXXXXX")
            Text("   XXXXXXXXXXX   XXX    XXXXXXXXXXXX      XXXXXXXXXXXXX")
            Text("   XXXXXXXXXXXX     XX    XXXXXXXXXX       XXXXXXXXXXXX")
            Text("   XXXXXXXXXXXXXX     X      XXXXXXX        XXXXXXXXXXX")
            Text("   XXXXXXXXXXXXXXX             XXXXX         XXXXXXXXXX")
            Text("   XXXXXXXXXXXXXXXXX              XX         XXXXXXXXXX")
            Text("   XXXXXXXXXXXXXXXXXXX                       XXXXXXXXXX")
            Text("   XXXXXXXXXXXXXXXXXXXXX                      XXXXXXXXX")
            Text("   XXXXXXXXXXXXXXXXXXXXXXXX                  XXXXXXXXXX")
            Text("   XXXXX      XXXXXXXXXXXXXXX                XXXXXXXXXX")
            Text("   XXXXXXX          XXX                       XXXXXXXXX")
            Text("   XXXXXXXXX                                   XXXXXXXX")
            Text("   XXXXXXXXXXXX                                 XXXXXXX")
            Text("   XXXXXXXXXXXXXXX                      XXXX    XXXXXXX")
            Text("   XXXXXXXXXXXXXXXXXXXX            XXXXXXXXXXX  XXXXXXX")
            Text("    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            Text("     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            Text("      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            Text("          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
        }
        .tint(.color256(202))
    }
    
    public init() {}
}
