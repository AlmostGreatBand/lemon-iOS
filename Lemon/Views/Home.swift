//
//  Home.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 15.10.2020.
//

import SwiftUI

struct Home: View {
    
    let maxCardHeight = UIScreen.main.bounds.width * 0.8 / 1.6
    
    @State var currentCardIndex = 0
    @State var showStickyHeader = false
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    @FetchRequest(
        entity: Card.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.id, ascending: true)],
        animation: .default)
    
    private var cards: FetchedResults<Card>
    
    var body: some View {
        if (cards.isEmpty) {
            // TODO: implement card adding
            Text("Wow, such empty")
        } else {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {

                        // Cards pager
                        GeometryReader { geometry in

                            let topSafeOffset = CGFloat(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)

                            let y = geometry.frame(in: .global).minY

                            CardsPager(cards: cards, currentIndex: $currentCardIndex)
                                .padding(.horizontal, 10)
                                .onReceive(self.time) { _ in
                                    if -y > topSafeOffset + 50 {
                                        withAnimation{
                                            self.showStickyHeader = true
                                        }
                                    } else {
                                        withAnimation{
                                            self.showStickyHeader = false
                                        }
                                    }
                                }
                        }
                        .frame(height: maxCardHeight)

                        TransactionsList(predicate: Transactions.predicate(cardID: cards[currentCardIndex].id, with: [], searchText: ""), sortDescriptor: TransactionsSort(sortType: SortType.date, sortOrder: SortOrder.ascending).sortDescriptor)
//                        TransactionsList(cardID: Int(cards[currentCardIndex].id))


                    }
                }.zIndex(0)

                if self.showStickyHeader {
                    Header(card: cards[currentCardIndex])
                        .zIndex(1)
                }
            }
            .background(Color(colorScheme == .dark ? UIColor.systemBackground : UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all)
            )
            
//            Wallet().animation(nil)
        }
    }
}

// Blur background
struct BlurBG: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
