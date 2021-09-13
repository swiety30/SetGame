//
//  SetGameApp.swift
//  SetGame
//
//  Created by Paweł Świątek on 24/08/2021.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(setGameViewModel: game)
        }
    }
}

/* Rules
// https://cs193p.sites.stanford.edu/sites/g/files/sbiybj16636/files/media/file/assignment_3_0.pdf
There are 4 features: shape / color / filling / number of shapes
 It's a set if for three cards
 All features are different (1 filled diamond red / 2 strap rombs green / 3 empty wave blue)
 One feature is common (1 filled diamond red / 1 strap rombs green / 1 empty wave blue)
Two features are common (1 filled diamond red / 1 filled rombs green / 1 filled wave blue)
 Three features are common (1 filled diamond red / 1 filled diamond green / 1 filled diamond blue)
 There is no possibility to have 4 common features
 We generate cards by creating each combination of color/ number /shapes / filling appear  once
 We display 12 cards
 If somebody picks set - he gets point, we fill in cards
 If somebody picks not set - he gets  -1 point
 If you cannot spot set, you can request adding new cards - 3 extra. So there is possibility to display 81 cards at once

 */
