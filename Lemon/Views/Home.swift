//
//  Home.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 15.10.2020.
//

import SwiftUI

struct Home: View {
    
    let maxCardHeight = UIScreen.main.bounds.width * 0.8 / 1.6
    
    func getDates(transactions: [TransactionObj]) -> [DateComponents] {
        var dates = [DateComponents]()
        for transaction in transactions {
            let components = transaction.date.get(.day, .month, .year)
            if !dates.contains(components) {
                dates.append(components)
            }
        }
        return dates.sorted { date1, date2 in
            let calendar = Calendar(identifier: .gregorian)
            
            return calendar.date(from: date1)! > calendar.date(from: date2)!
        }
    }
    
    func getTransactionsByDate(transactions: [TransactionObj], date: DateComponents) -> [TransactionObj] {
        return transactions.filter { transaction in
            let components = transaction.date.get(.day, .month, .year)
            return components == date
        }
    }
    
    @State var currentCardIndex = 0
    @State var showStickyHeader = false
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    // Cards pager
                    GeometryReader { geometry in
                        
                        let topSafeOffset = CGFloat(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                        let y = geometry.frame(in: .global).minY
                        
                        PagerView(pageCount: cards.count, currentIndex: $currentCardIndex) {
                            ForEach(cards, id: \.id) { card in
                                CardView(card: card)
                                    .animation(nil)
                            }
                        }
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
                    
                    // Transactions
                    VStack(alignment: .leading) {
                        let cardTransactions = transactions.filter { transaction in
                            return transaction.card == cards[currentCardIndex]
                        }
                        
                        ForEach(getDates(transactions: cardTransactions), id: \.self) { date in
                            HStack(spacing: 5) {
                                Text("\(date.day!)")
                                Text("\(DateFormatter().monthSymbols[date.month! - 1])")
                            }
                            .font(.headline)
                            .padding([.leading, .top])
                            .padding(.bottom, 5)
                            
                            let transactions = getTransactionsByDate(transactions: cardTransactions, date: date)
                            
                            VStack {
                                ForEach(transactions) { transaction in
                                    TransactionRow(transaction: transaction)
                                        .frame(height: 45)
                                        .padding(.bottom, 1)
                                    Divider()
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, -1)
                            .background(Color(colorScheme == .dark ? UIColor.secondarySystemBackground : UIColor.systemBackground))
                            .cornerRadius(18)
                        }
                        .animation(nil)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .padding(10)
                    .transition(.opacity)
                    .animation(.spring())
                }
            }.zIndex(0)

            if self.showStickyHeader {
                Header(card: cards[currentCardIndex])
                    .zIndex(1)
            }
        }
        .background(Color(colorScheme == .dark ? UIColor.systemBackground : UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all)
        )
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
        Home()
    }
}


// MARK: -Temp

var transactions = [
    TransactionObj(card: cards[0], amount: -100000, name: "Buy new iPhone", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .shopping),
    TransactionObj(card: cards[1], amount: -50000, name: "Starbucks Coffee", date: Date(timeIntervalSinceNow: .random(in: -100000...0)), type: .food),
    TransactionObj(card: cards[1], amount: 300000, name: "Salary", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .income),
    TransactionObj(card: cards[0], amount: -1000, name: "Subway", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .transportation),
    TransactionObj(card: cards[1], amount: -25000, name: "Pistons for car", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .transportation),
    TransactionObj(card: cards[1], amount: -1500000, name: "Rent", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .utilities),
    TransactionObj(card: cards[0], amount: -8000, name: "Grocery", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .food),
    TransactionObj(card: cards[1], amount: 300000, name: "Salary", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .income),
    TransactionObj(card: cards[0], amount: -100000, name: "Buy new iPhone", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .shopping),
    TransactionObj(card: cards[0], amount: -50000, name: "Starbucks Coffee", date: Date(timeIntervalSinceNow: .random(in: -100000...0)), type: .food),
    TransactionObj(card: cards[1], amount: 300000, name: "Salary", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .income),
    TransactionObj(card: cards[0], amount: -1000, name: "Subway", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .transportation),
    TransactionObj(card: cards[1], amount: -25000, name: "Pistons for car", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .transportation),
    TransactionObj(card: cards[1], amount: -1500000, name: "Rent", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .utilities),
    TransactionObj(card: cards[0], amount: -8000, name: "Grocery", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .food),
    TransactionObj(card: cards[1], amount: 300000, name: "Salary", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .income),
    TransactionObj(card: cards[0], amount: -100000, name: "Buy new iPhone", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .shopping),
    TransactionObj(card: cards[2], amount: -50000, name: "Starbucks Coffee", date: Date(timeIntervalSinceNow: .random(in: -100000...0)), type: .food),
    TransactionObj(card: cards[1], amount: 300000, name: "Salary", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .income),
    TransactionObj(card: cards[0], amount: -1000, name: "Subway", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .transportation),
    TransactionObj(card: cards[1], amount: -25000, name: "Pistons for car", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .transportation),
    TransactionObj(card: cards[1], amount: -1500000, name: "Rent", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .utilities),
    TransactionObj(card: cards[0], amount: -8000, name: "Grocery", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .food),
    TransactionObj(card: cards[1], amount: 300000, name: "Salary", date: Date(timeIntervalSinceNow: .random(in: -1000000...0)), type: .income),
]
