//
//  TransactionList.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 17.10.2020.
//

import SwiftUI
import CoreData

struct TransactionsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    var cardID: Int
    
    var transactionsRequest: FetchRequest<Transactions>
    var transactions: FetchedResults<Transactions> { transactionsRequest.wrappedValue }
    
    init(cardID: Int) {
        self.cardID = cardID
        
        transactionsRequest = FetchRequest<Transactions>(
            entity: Transactions.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "cardID == %@", String(cardID))
        )
    }
    
    func getDates() -> [DateComponents] {
        var dates = [DateComponents]()
        transactions.forEach { transaction in
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
    
    func getTransactionsByDate(date: DateComponents) -> [Transactions] {
        return transactions.filter { transaction in
            let components = transaction.date.get(.day, .month, .year)
            return components == date
        }
    }
    
    var body: some View {
        // Transactions
        VStack(alignment: .leading) {

            ForEach(getDates(), id: \.self) { date in
                HStack(spacing: 5) {
                    Text("\(date.day!)")
                    Text("\(DateFormatter().monthSymbols[date.month! - 1])")
                }
                .font(.headline)
                .padding([.leading, .top])
                .padding(.bottom, 5)

                let transactions = getTransactionsByDate(date: date)

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
}

struct TransactionList_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsList(cardID: 0).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
