//
//  TransactionView.swift
//  Lemon
//
//  Created by Anna Vasylashko on 12.10.2020.
//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction
    
    var body: some View {
        HStack {
            IconView(type: transaction.type)
            Text(transaction.name)
            
            Spacer()
            
            HStack(spacing: 5) {
                Text("\(transaction.amount > 0 ? "+" : "")\(Double(transaction.amount / 100), specifier: "%.2f")")
                Text(transaction.card.currency)
            }
            .foregroundColor(transaction.amount > 0 ? Color.green : Color.red)
        }
        .padding()
    }
}

struct IconView: View {
    var type: TransactionType
    
    var body: some View {
        let icon = icons[type] ?? icons[.shopping]!
        
        Image(systemName: icon.name)
            .font(.system(size: 18, weight: .bold))
            .padding(8)
            .foregroundColor(Color.white)
            .background(icon.color)
            .cornerRadius(8)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: Transaction(card: cards[0], amount: -100000, name: "Buy new iPhone", type: .shopping))
    }
}

enum TransactionType {
    case donation, entertainment, food, health,
         shopping, transportation, utilities
}

struct Transaction {
    var card: Card
    var amount: Int
    var name: String
    var type: TransactionType
}

fileprivate struct Icon {
    var name: String
    var color: Color
}

fileprivate var icons: [TransactionType: Icon] = [
    .donation: Icon(name: "suit.heart", color: .pink),
    .entertainment: Icon(name: "tv", color: .orange),
    .food: Icon(name: "cart", color: .green),
    .health: Icon(name: "staroflife", color: .red),
    .shopping: Icon(name: "bag", color: .yellow),
    .transportation: Icon(name: "car", color: .purple),
    .utilities: Icon(name: "house", color: .blue)
]
