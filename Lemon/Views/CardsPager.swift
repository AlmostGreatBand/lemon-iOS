//
//  PagerView.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 10.10.2020.
//

import SwiftUI

struct CardsPager: View {

    var pageCount: Int {
        return cards.count
    }

    // stores current page's index
    @Binding var currentIndex: Int
    // translation of current page relatively to it's default position
    @State private var translation = CGFloat.zero

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Card.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.id, ascending: true)],
        animation: .default
    ) var cards: FetchedResults<Card>

    // func to get right offset
    func getNeededOffset(width: CGFloat) -> CGFloat {
        let cardWidthWithSpacing = 0.8 * width + 10

        if currentIndex == 0 {
            return 0
        } else if currentIndex == pageCount - 1 {
            return -CGFloat(currentIndex) * cardWidthWithSpacing + cardWidthWithSpacing * 0.25
        }

        let firstOffset = -CGFloat(currentIndex) * cardWidthWithSpacing * 0.875
        let offset = firstOffset - CGFloat(currentIndex - 1) * cardWidthWithSpacing * 0.125

        return offset
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                ForEach(cards.indices) { index in
                    CardView(card: cards[index])
                        .frame(width: geometry.size.width * 0.8)
                        .rotation3DEffect(Angle(degrees: (Double(self.translation / 40))), axis: (x: 0, y: -10.0, z: 0))
                        .scaleEffect(1 - min(abs(self.translation / 1000), 0.05))
                }
            }
            .offset(x: getNeededOffset(width: geometry.size.width))
            .offset(x: self.translation)

            .gesture(
                DragGesture().onChanged() { gesture in
                    self.translation = gesture.translation.width * 0.8
                }.onEnded { value in
                    if abs(self.translation) > 0.5 * geometry.size.width * 0.8 {
                        let offset = value.translation.width / geometry.size.width * 1.5
                        let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                        self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                    }
                    self.translation = .zero
                }
            )
            .animation(.spring())
        }
    }
}

struct CardsPager_Previews: PreviewProvider {
    static var previews: some View {
        CardsPager(currentIndex: .constant(0)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
