//
//  TransactionsListOptions.swift
//  Lemon
//
//  Created by Anna Vasylashko on 30.12.2020.
//

import SwiftUI

struct TransactionsListOptions: View {

    @Binding var types: [TransactionType]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(TransactionType.allCases, id: \.self) { type in
                    MultipleSelectionRow(title: type.rawValue, isSelected: types.contains(type)) {
                        if types.contains(type) {
                            types.removeAll(where: { $0 == type })
                        }
                        else {
                            types.append(type)
                        }
                    }
                }
            }.navigationTitle("Filter")
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct TransactionsListOptions_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsListOptions(types: .constant([]))
    }
}
