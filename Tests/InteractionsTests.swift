//
//  InteractionsTests.swift
//  InteractionsTests
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Testing
@testable import Interactions

struct InteractionsTests {

    @Test func example() async throws {
        print(wrapLinesByWords(text: "That’s pretty cool, but where key paths really start to shine is when they’re used to form slightly more complex expressions, such as when sorting a sequence of values.", width: 80).split(separator: "\n"))
    }

}
