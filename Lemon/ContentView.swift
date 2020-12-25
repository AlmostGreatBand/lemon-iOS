//
//  ContentView.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 07.10.2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView {
            Wallet().navigationBarTitle("Wallet")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
