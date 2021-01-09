//
//  Wallet.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 02.11.2020.
//

import SwiftUI

struct Wallet: View {
    
    // Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Currently picked card
    @State private var cardPicked: Card?
    
    // Manage which view to show at the moment
    @State private var isTransactionsVisible = false
    @State private var isCardInvisible = false

    // Variables to store cards positions
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    
    // Is filter options view shown
    @State var showOptions = false
    
    // Transaction types to show
    @State var types: [TransactionType] = TransactionType.allCases
    
    // Core Data request for all cards
    @FetchRequest(
        entity: Card.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.id, ascending: true)],
        animation: .default
    ) var cards: FetchedResults<Card>
    
    // Get card's offset on screen
    func getOffset(indexOfCard: Int, size: CGSize) -> CGFloat {
        
        let height = size.height
        let cardHeight = size.width / 1.6
        
        if let cardPicked = self.cardPicked {
            let indexOfPickedCard = cards.firstIndex(of: cardPicked)!
            
            return indexOfCard <= indexOfPickedCard ? 0 : size.height + 100
        }
        
        if currentPosition.height >= height - CGFloat(indexOfCard) * 80 - cardHeight - CGFloat(cards.endIndex - indexOfCard) * 20 {
            return height - cardHeight - CGFloat(cards.endIndex - indexOfCard) * 20
        }
        
        if currentPosition.height >= 0 {
            return CGFloat(indexOfCard) * 80
        }
        
        if currentPosition.height >= -CGFloat(indexOfCard) * 60 {
            return currentPosition.height + CGFloat(indexOfCard) * 80
        }
        
        return CGFloat(indexOfCard) * 20
    }

    var body: some View {
        GeometryReader { geometry in
            
            // If card is picked, animate cards dissapearing and show transactions list of current card
            if self.cardPicked != nil {
                ScrollView {
                    VStack {
                        // Picked card on top
                        CardView(card: cardPicked!)
                            .frame(height: geometry.size.width / 1.6)
                            .offset(y: getOffset(indexOfCard: cards.firstIndex(of: cardPicked!)!, size: geometry.size))
                            .padding(.horizontal)
                            .onTapGesture {
                                isCardInvisible = false
                                
                                withAnimation {
                                    self.cardPicked = nil
                                }
                            }
                            .animation(.easeInOut)
                        
                        // Transactions
                        TransactionsList(predicate: Transactions.predicate(cardID: cardPicked?.id, of: types))
                    }
                }
                .opacity(isTransactionsVisible ? 1 : 0)
                .onAppear {
                    withAnimation {
                        isTransactionsVisible = true
                    }
                }
                .onDisappear {
                    isTransactionsVisible = false
                }
            }
            
            // Cards
            ZStack {
                ForEach(cards) { card in
                    let indexOfCard = cards.firstIndex(of: card) ?? 0
                        
                    CardView(card: card)
                        .frame(height: geometry.size.width / 1.6)
                        .offset(y: getOffset(indexOfCard: indexOfCard, size: geometry.size))
                        .zIndex(Double(indexOfCard))
                        .onTapGesture {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.isCardInvisible = true
                            }
                            
                            withAnimation {
                                self.cardPicked = cards[indexOfCard]
                            }
                        }
                        .animation(.easeInOut)
                        
                        
                        .opacity(isCardInvisible ? 0 : 1)
                        .animation(nil)
                }
            }
            .padding(.horizontal)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let height = value.translation.height + self.newPosition.height
                        
                        self.currentPosition = CGSize(width: 0, height: height)
                    }
                    .onEnded { value in
                        var height = value.translation.height + self.newPosition.height
                        
                        
                        if height <= geometry.size.height - CGFloat(cards.endIndex) * 120 - geometry.size.width / 1.6 {
                            withAnimation {
                                height = geometry.size.height - CGFloat(cards.endIndex) * 120 - geometry.size.width / 1.6
                            }
                        }
                        
                        if height >= 0 {
                            withAnimation {
                                height = 0
                            }
                        }
                        
                        self.currentPosition = CGSize(width: 0, height: height)
                        self.newPosition = self.currentPosition
                    }
            )
            .animation(.easeInOut)
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        .toolbar {
            // Button to show filter options
            ToolbarItem(placement: .primaryAction) {
                if cardPicked != nil {
                    Button(action: { showOptions.toggle() }) {
                        Text("Filter")
                    }
                    .sheet(isPresented: $showOptions) {
                        TransactionsListOptions(types: $types)
                    }
                }
            }
        }
        .navigationBarTitle(
            Text("\(cardPicked?.bank ?? "Wallet") \(cardPicked?.type ?? "")"),
            displayMode: .large
        )
    }
}

struct Wallet_Previews: PreviewProvider {
    static var previews: some View {
        Wallet()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
