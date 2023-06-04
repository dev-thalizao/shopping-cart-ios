//
//  ContentView.swift
//  CartApp
//
//  Created by Thales Frigo on 04/06/23.
//

import SwiftUI
import CartEngine

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(CartEngine().text)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
