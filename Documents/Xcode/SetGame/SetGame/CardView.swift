//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Paweł Świątek on 10/08/2021.
//

import SwiftUI

struct CardView: View {
    let item: SetGameModel.Card

    var body: some View {

        let range = 1...item.atribiutes.number.rawValue
        ZStack {
            RoundedRectangle(cornerRadius: DrawingConstants.Card.cornerRadious)
                .stroke(lineWidth: DrawingConstants.Card.borderLineWidth)
                .foregroundColor(.orange)
            RoundedRectangle(cornerRadius: DrawingConstants.Card.cornerRadious)
                .opacity(DrawingConstants.Card.backgroundOpacity)
                .foregroundColor(.yellow)
            GeometryReader { geometry in
                VStack {
                    ForEach(range, id: \.self) { index in
                        let y = geometry.size.height - 10
                        let y2 = countYValue(for: y, itemNumber: item.atribiutes.number, currentInt: index)
                        let point = CGPoint(x: 0, y: y2)
                        let width = geometry.size.width
                        let height = (geometry.size.height / 3 ) - 10
                        CardShape(item: item, size: CGRect(origin: point,
                                                           size: CGSize(width: width,
                                                                        height: height)))
                            .makeBeautifulShape()
                    }
                }
            }.padding()

            if item.isSelected {
                RoundedRectangle(cornerRadius: DrawingConstants.Card.cornerRadious)
                    .stroke(lineWidth: DrawingConstants.Card.selectedLineWidth)
                    .foregroundColor(DrawingConstants.Card.selectedColor)
            }
        }
    }

    private func countYValue(for height: CGFloat, itemNumber: SetGameModel.Number, currentInt: Int) -> CGFloat {
        switch itemNumber {
        case .one: return height / 2.5
        case .two:
            if currentInt == 1 {
                return height / 8
            } else {
                return height / 16
            }
        case .three:
            if currentInt == 1 {
                return height / 32
            } else if  currentInt == 2 {
                return height / 40
            } else {
                return height / 48
            }
        }
    }
}

struct CardShape: Shape {
    let item: SetGameModel.Card
    let size: CGRect

    func path(in rect: CGRect) -> Path {
        var rectFixed = rect
        rectFixed.size.height = size.height
        rectFixed.origin.y = size.origin.y
        switch item.atribiutes.shape {
            case .diamond: return Diamond().path(in: rectFixed)
            case .rectangle: return Rectangle().path(in: rectFixed)
            case .circle: return Circle().path(in: rectFixed)
        }
    }
}

extension CardShape {
    @ViewBuilder
    func makeBeautifulShape() -> some View {
        let color = getColor()
        
        switch item.atribiutes.filling {
            case .empty: self.stroke(lineWidth: DrawingConstants.Figures.lineWidth).foregroundColor(color)
            case .opacity: ZStack {
                self.stroke(lineWidth: DrawingConstants.Figures.lineWidth).foregroundColor(color)
                self.fill().foregroundColor(color).opacity(DrawingConstants.Figures.opacityOpacity)

                }
            case .solid: ZStack {
                self.stroke(lineWidth: DrawingConstants.Figures.lineWidth).foregroundColor(color)
                self.fill().foregroundColor(color).opacity(DrawingConstants.Figures.solidOpacity)
                }
        }
    }

    private func getColor() -> Color {
        let color: Color
        switch item.atribiutes.color {
            case .blue: color = Color.blue
            case .green: color = Color.green
            case .red: color = Color.red
        }
        return color
    }
}

private struct DrawingConstants {
    struct Card {
        static let cornerRadious: CGFloat = 20
        static let borderLineWidth: CGFloat = 3.0
        static let selectedLineWidth: CGFloat = 4.0
        static let selectedColor: Color = .red
        static let backgroundOpacity: Double = 0.5
    }
    struct Figures {
        static let lineWidth: CGFloat = 2.0
        static let opacityOpacity: Double = 0.3
        static let solidOpacity: Double = 0.8
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(item: SetGameModel.Card(id: 1,
                                         atribiutes: SetGameModel.CardAtribiutes(shape: .circle,
                                                                                 number: .one,
                                                                                 filling: .opacity,
                                                                                 color: .green)))
    }
}
