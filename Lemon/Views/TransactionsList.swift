//
//  TransactionsList.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 01.11.2020.
//

import SwiftUI
import CoreData

struct TransactionsList: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) var colorScheme

    @FetchRequest(
        entity: Transactions.entity(),
        sortDescriptors: []
    )
    private var result: FetchedResults<Transactions>

    init(predicate: NSPredicate?) {
        let fetchRequest = NSFetchRequest<Transactions>(entityName: Transactions.entity().name ?? "Transactions")

        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Transactions.date, ascending: true)]
        
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    func getDates() -> [DateComponents] {
        var dates = [DateComponents]()
        result.forEach { transaction in
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
        return result.filter { transaction in
            let components = transaction.date.get(.day, .month, .year)
            return components == date
        }
    }

    var body: some View {
        if (result.isEmpty) {
            Text("Empty")
        } else {
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
        }
    }

    private func onDelete(with indexSet: IndexSet) {
        // TODO: Implement Delete
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

struct TestPredicate_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsList(predicate: Transactions.predicate(cardID: nil, of: []))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
