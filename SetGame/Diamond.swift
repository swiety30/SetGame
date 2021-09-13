//
//  Diamond.swift
//  SetGa e
//
//  Created by Paweł Świątek on 10/08/2021.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {

        let start = CGPoint(x: rect.midX, y: rect.minY)
        let leftEdge = CGPoint(x: rect.minX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)
        let rightEdge = CGPoint(x: rect.maxX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.minY)
        var path = Path()

        path.move(to: start)
        path.addLine(to: leftEdge)
        path.addLine(to: bottom)
        path.addLine(to: rightEdge)
        path.addLine(to: top)

        return path
    }
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
    }
}
