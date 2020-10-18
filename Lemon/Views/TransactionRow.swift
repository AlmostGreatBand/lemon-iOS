//
//  TransactionView.swift
//  Lemon
//
//  Created by Anna Vasylashko on 12.10.2020.
//

import SwiftUI

struct TransactionRow: View {
    var transaction: Transactions
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    var cardsRequest: FetchRequest<Card>
    var cards: FetchedResults<Card> { cardsRequest.wrappedValue }

    init(transaction: Transactions) {
        self.transaction = transaction
        
        cardsRequest = FetchRequest<Card>(
            entity: Card.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", String(transaction.cardID))
        )
    }
    
    var body: some View {
        HStack {
            IconView(type: transaction.transactionType)
            Text(transaction.name.isEmpty ? transaction.transactionType.rawValue : transaction.name)
                .lineLimit(3)
            
            Spacer()
            
            HStack(spacing: 5) {
                Spacer()
                Text("\(transaction.amount > 0 ? "+" : "")\(Double(transaction.amount / 100), specifier: "%.2f")")
                Text(cards.first?.currency ?? "")
            }
            .foregroundColor(transaction.amount > 0 ? Color.green : Color.red)
            .frame(minWidth: 70)
            .fixedSize(horizontal: true, vertical: false)
            .lineLimit(1)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct IconView: View {
    var type: TransactionType
    
    var body: some View {
        let icon = icons[type] ?? icons[.shopping]!
        
        Image(systemName: icon.name)
            .font(.system(size: 18, weight: .bold))
            .frame(width: 35, height: 35, alignment: .center)
            .foregroundColor(Color.white)
            .background(icon.color)
            .cornerRadius(8)
    }
}

fileprivate struct Icon {
    var name: String
    var color: Color
}

fileprivate var icons: [TransactionType: Icon] = [
    .donation: Icon(name: "suit.heart", color: .pink),
    .entertainment: Icon(name: "tv", color: .orange),
    .food: Icon(name: "cart", color: Color(UIColor.systemTeal)),
    .health: Icon(name: "staroflife", color: .red),
    .shopping: Icon(name: "bag", color: .yellow),
    .transportation: Icon(name: "car", color: .purple),
    .utilities: Icon(name: "house", color: .blue),
    .income: Icon(name: "dollarsign.circle", color: .green)
]
