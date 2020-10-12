//
//  CardView.swift
//  Lemon
//
//  Created by Anna Vasylashko on 09.10.2020.
//

import SwiftUI

struct CardView: View {
    
    // MARK: - Variables
    
    var card: Card
    
    // Card corners' radius
    var radius = CGFloat(25)
    
    // Card's aspect ratio
    var aspectRatio = CGFloat(1.6)
    
    // MARK: - Views
    var body: some View {
        let colorName = cardColors.contains(self.card.color) ? self.card.color : cardColors.randomElement()!
        
        let startColor = Color(UIColor(named: "\(colorName)Start")!)
        let endColor = Color(UIColor(named: "\(colorName)End")!)
        let shadowColor = Color(UIColor(named: "\(colorName)Shadow")!)
        
        ZStack {
            
            // Shadow
            RoundedRectangle(cornerRadius: radius)
                .fill(Color.white.opacity(1))
                .aspectRatio(aspectRatio, contentMode: .fit)
                .padding(30)
                .shadow(color: shadowColor, radius: 20, y: 25)
            
            GeometryReader{ geometry in
                
                let w = geometry.size.width
                let h = w / aspectRatio
                
                // Gradient background
                Rectangle().fill(LinearGradient(
                    gradient: .init(colors: [startColor, endColor]),
                    startPoint: .init(x: 0, y: 1),
                    endPoint: .init(x: 1, y: 0)
                ))
                
                // Card's upper decoration
                Path { path in
                    path.addEllipse(in: CGRect(x: w / 3, y: -1.5 * h, width: 2 * h, height: 2 * h), transform: .identity)
                }
                .fill(Color.white.opacity(0.15))
                
                // Card's bottom decoration
                Path { path in
                    path.addEllipse(in: CGRect(x: -w , y: h / 2, width: 2 * w, height: 2 * w), transform: .identity)
                }
                .fill(Color.white.opacity(0.1))
                
                // Card info
                VStack {
                    
                    // Currency and balance
                    HStack {
                        Text("\(card.currency)  \(Double(card.balance / 100), specifier: "%.2f")")
                        
                        Spacer()
                    }
                    .font(Font.system(size:25, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    // Card's number
                    HStack {
                        ForEach(1..<4) {_ in
                            Text("••••")
                            Spacer()
                        }
                        Text("\(String(card.number))")
                    }
                    .font(.system(size: 22))
                    .padding(.bottom, 5)
                    
                    // Bank and type
                    HStack {
                        Text("\(card.bank)  \(card.type)")
                        Spacer()
                    }
                    .font(.system(size: 18, weight: .medium))
                }
                .foregroundColor(Color.black)
                .minimumScaleFactor(0.05)
                .lineLimit(1)
                .padding(30)
            }
            .mask(RoundedRectangle(cornerRadius: radius))
            .aspectRatio(aspectRatio, contentMode: .fit)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            card: Card(id: 0, bank: "monobank", number: 1234, type: "black", balance: 100000000000, currency: "UAH", color: "Sapphire")
        )
        .padding()
    }
}

// MARK: - Temp
// Temporary here. Replace to Model later
// Fields can change becase DB is not finished yet.

struct Card: Hashable {
    var id: Int
    var bank: String
    var number: Int
    var type: String
    var balance: Int
    var currency: String
    var color: String
}

var cardColors = ["Peach", "Lime", "Sapphire"]
