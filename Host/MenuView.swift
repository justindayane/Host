//
//  ContentView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/16/25.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel = MenuViewModel()
    
    var body: some View {
        ZStack (alignment: .bottomTrailing){
            ScrollView {
                ForEach(viewModel.people) { person in
                    HStack {
                        Text(person.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(person.phoneNumber)
                            Text(person.email)
                        }
                    }
                    .frame(height: 80)
                    .padding(12)
                }
            }
            
            Menu("Menu".uppercased()) {
                Button("Reverse", action: viewModel.reverseOrder)
                Button("Shuffle", action: viewModel.shuffleOrder)
                Button("RemoveLast", action: viewModel.removeLast)
                Button("RemoveFirst", action: viewModel.removeFirst)
            }
            .padding()
        }
    }
}

#Preview {
    MenuView()
}
