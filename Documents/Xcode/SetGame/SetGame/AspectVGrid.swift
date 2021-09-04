//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Paweł Świątek on 10/08/2021.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var maxItemCount: Int
    var content: (Item) -> ItemView

    var body: some View {
        GeometryReader { geometry in
            let vStack = VStack {
                let width: CGFloat = widthThatFits(in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                            .padding(5)
                    }
                }
            }.padding()
            ZStack {
                if items.count > maxItemCount {
                    ScrollView(showsIndicators: false) {
                        vStack
                    }
                } else {
                    vStack
                }

                Spacer(minLength: 0)
            }
        }
    }

    init(items: [Item], maxItemCount: Int, aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items =  items
        self.aspectRatio = aspectRatio
        self.content = content
        self.maxItemCount = maxItemCount
    }

    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }

    private func widthThatFits(in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = maxItemCount
        let itemCount = maxItemCount

        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}
