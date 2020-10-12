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
    
    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
            self.pageCount = pageCount
            self._currentIndex = currentIndex
            self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width * 0.86)
                    .padding(.horizontal, geometry.size.width * 0.02)
                    .rotation3DEffect(Angle(degrees: (Double(self.translation / 40))), axis: (x: 0, y: -10.0, z: 0))
            }
            .frame(width: geometry.size.width * 0.98, alignment: .leading)
            
            .padding(.horizontal, geometry.size.width * 0.02)
            
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width * 0.87)
            .offset(x: self.translation)
            
            .scaleEffect(1 - min(abs(self.translation / (geometry.size.width * 5)), 0.08))
            
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
    Card(id: 1, bank: "monobank", number: 1234, type: "black", balance: 10000, currency: "USD", color: "Lime"),
    Card(id: 2, bank: "monobank", number: 1234, type: "black", balance: 10000, currency: "USD", color: "Sapphire"),
    Card(id: 3, bank: "monobank", number: 1234, type: "black", balance: 10000, currency: "USD", color: "Peach"),
]
