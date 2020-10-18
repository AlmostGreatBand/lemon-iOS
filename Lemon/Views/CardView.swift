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
    var radius = CGFloat(18)
    
    // Card's aspect ratio
    var aspectRatio = CGFloat(1.6)
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Views
    var body: some View {
        let colorName = cardColors.contains(self.card.color) ? self.card.color : cardColors.randomElement()!
        
        let startColor = Color(UIColor(named: "\(colorName)Start")!)
        let endColor = Color(UIColor(named: "\(colorName)End")!)
        let shadowColor = Color(UIColor(named: "\(colorName)Shadow")!)
        
        ZStack {
            
            if colorScheme != .dark {
                // Shadow
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.white.opacity(1))
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .padding(30)
                    .shadow(color: shadowColor, radius: 20, y: 15)
            }
            
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
                VStack(alignment: .leading) {
                    
                    // Currency and balance
                    Text("\(card.currency)  \(Double(card.balance / 100), specifier: "%.2f")")
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
                    
                    Spacer()
                    
                    // Bank and type
                    Text(card.bank)
                        .bold()
                    
                    Text(card.type)
                }
                .foregroundColor(Color.black)
                .minimumScaleFactor(0.05)
                .lineLimit(1)
                .padding(20)
            }
            .mask(RoundedRectangle(cornerRadius: radius))
            .aspectRatio(aspectRatio, contentMode: .fit)
        }
    }
}

var cardColors = ["Peach", "Lime", "Sapphire"]
