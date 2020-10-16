//
//  PagerView.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 10.10.2020.
//

import SwiftUI

struct PagerView<Content: View>: View {
    
    // number of pages
    let pageCount: Int
    // scope of View type
    let content: Content
    
    // stores current page's index
    @Binding var currentIndex: Int
    // translation of current page relatively to it's default position
    @GestureState private var translation: CGFloat = 0
    
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
    
    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
            self.pageCount = pageCount
            self._currentIndex = currentIndex
            self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                self.content
                    .frame(width: geometry.size.width * 0.8)
                    .rotation3DEffect(Angle(degrees: (Double(self.translation / 40))), axis: (x: 0, y: -10.0, z: 0))
            }
            .offset(x: getNeededOffset(width: geometry.size.width))
            .offset(x: self.translation)
            
            .scaleEffect(1 - min(abs(self.translation / 1000), 0.1))
            
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width * 1.5
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
            .animation(.spring())
        }
    }
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        PagerView(pageCount: cards.count, currentIndex: .constant(0)) {
            ForEach(cards, id: \.id) { card in
                CardView(card: card)
            }
        }
    }
}

// MARK: - Temporary for visual representation of future data

var cards = [
    Card(id: 1, bank: "Monobank", number: 1234, type: "Black", balance: 10000, currency: "USD", color: "Lime"),
    Card(id: 2, bank: "PrivatBank", number: 1234, type: "Gold", balance: 10000, currency: "USD", color: "Sapphire"),
    Card(id: 3, bank: "PrivatBank", number: 1234, type: "Regular", balance: 10000, currency: "USD", color: "Peach"),
    Card(id: 4, bank: "PrivatBank", number: 1234, type: "Card for payments", balance: 10000, currency: "USD", color: "Lime"),
    Card(id: 5, bank: "Monobank", number: 1234, type: "Platinun", balance: 10000, currency: "USD", color: "Sapphire"),
    Card(id: 6, bank: "Monobank", number: 1234, type: "Black", balance: 10000, currency: "USD", color: "Peach"),
]
