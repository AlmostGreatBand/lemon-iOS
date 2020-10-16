//
//  TransactionView.swift
//  Lemon
//
//  Created by Anna Vasylashko on 12.10.2020.
//

import SwiftUI

struct TransactionRow: View {
    var transaction: TransactionObj
    
    var body: some View {
        HStack {
            IconView(type: transaction.type)
            Text(transaction.name)
                .minimumScaleFactor(0.05)
                .lineLimit(3)
            
            Spacer()
            
            HStack(spacing: 5) {
                Spacer()
                Text("\(transaction.amount > 0 ? "+" : "")\(Double(transaction.amount / 100), specifier: "%.2f")")
                Text(transaction.card.currency)
            }
            .foregroundColor(transaction.amount > 0 ? Color.green : Color.red)
            .frame(maxWidth: .infinity)
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

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: TransactionObj(card: cards[0], amount: -100000, name: "Buy new iPhone", date: Date(), type: .shopping))
    }
}

enum TransactionType {
    case donation, entertainment, food, health,
         shopping, transportation, utilities, income
}

struct TransactionObj: Identifiable {
    var id = UUID()
    var card: Card
    var amount: Int
    var name: String
    var date: Date
    var type: TransactionType
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
