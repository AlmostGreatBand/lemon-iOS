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
//        let shadowColor = Color(UIColor(named: "\(colorName)Shadow")!)
        
        ZStack {
            
            if colorScheme != .dark {
                // Shadow
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.white.opacity(1))
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .padding(30)
//                    .shadow(color: shadowColor, radius: 20, y: 15)
            }
            
            GeometryReader{ geometry in
                
                let w = geometry.size.width
                let h = w / aspectRatio
                
                // Gradient background
                Rectangle().fill(LinearGradient(
                    gradient: .init(colors: [startColor, endColor]),
                    startPoint: .init(x: 0, y: 1),
                    endPoint: .init(x: 1, y: 0)
                )).overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color.black.opacity(0.2), lineWidth: 2)
                )
                
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
                    
                    // Bank, type and number
                    HStack {
                        
                        Text(card.bank)
                            .bold()
                        
                        Text(card.type)
                        
                        Spacer()
                        
                        Text("••••  \(String(card.number))")
                    }
                    .font(.system(size: 22))
                    
                    
                    Spacer()
                    
                    // Chip
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(
                                gradient: .init(colors: [
                                    Color(UIColor.init(named: "GoldStart")!),
                                    Color(UIColor.init(named: "GoldEnd")!)
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            ))
                            .frame(width: 55, height: 40)
                        
                        VStack {
                            Rectangle()
                                .stroke(Color.white.opacity(0.7), lineWidth: 2)
                                .frame(width: 55, height: 12)
                            
                            Spacer()
                            
                            Rectangle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 55, height: 12)
                        }
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(
                                gradient: .init(colors: [
                                    Color(UIColor.init(named: "GoldStart")!),
                                    Color(UIColor.init(named: "GoldEnd")!)
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            ))
                            .frame(width: 20, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .frame(width: 55, height: 40)
                    .padding(.bottom, 30)
                    
                    Spacer()
                    
                    // Currency and balance
                    Text("\(card.currency)  \(Double(card.balance / 100), specifier: "%.2f")")
                        .font(Font.system(size:25, weight: .bold, design: .rounded))
                    
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

struct MiniCardView: View {
    var card: Card
    
    var body: some View {
        let colorName = cardColors.contains(self.card.color) ? self.card.color : cardColors.randomElement()!
        
        let startColor = Color(UIColor(named: "\(colorName)Start")!)
        let endColor = Color(UIColor(named: "\(colorName)End")!)
        
        RoundedRectangle(cornerRadius: 6).fill(LinearGradient(
            gradient: .init(colors: [startColor, endColor]),
            startPoint: .init(x: 0, y: 1),
            endPoint: .init(x: 1, y: 0)
        ))
    }
}

var cardColors = ["Peach", "Lime", "Sapphire"]
