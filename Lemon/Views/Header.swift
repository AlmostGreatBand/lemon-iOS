//
//  Header.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 16.10.2020.
//

import SwiftUI

struct Header: View {
    var card: Card
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(card.bank)")
                    .bold()
                
                Spacer()
                
                Text("\(Double(card.balance / 100), specifier: "%.2f") \(card.currency)")
                    .font(.system(size: 20, weight: .regular))
            }
            
            Text(card.type)
            
            Text("•••• •••• •••• \(String(card.number))")
        }
        .padding(20)
        .padding(.bottom, 15)
        .frame(height: 100)
        .background(BlurBG().edgesIgnoringSafeArea(.top))
    }
}
