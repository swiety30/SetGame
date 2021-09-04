//
//  Array+Extension.swift
//  SetGame
//
//  Created by Paweł Świątek on 27/08/2021.
//

import Foundation

extension Array {
    func getRandom(elements: Int) -> Array {
        let shuffled = self.shuffled()
        return Array(shuffled.prefix(elements))
    }
}
