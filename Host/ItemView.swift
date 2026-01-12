//
//  ItemView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 11/17/25.
//

import SwiftUI

struct ItemView: View {
    let item: MenuItem
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "fork.knife")
                    //                    .resizable()
                    //                    .frame(width: 25, height: 25)
                    Text(item.name)
                        .font(.subheadline)
                    //                    .bold()
                    Spacer()
                }
                HStack {
                    Text("Diets: \(item.diets.map { $0.title }.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(item.nutrition)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(15)
            .shadow(radius: 2)
            HStack {
                Spacer()
                VStack (alignment: .trailing) {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(item.diets.contains(.carbControl) && item.diets.contains(.cardiac) ? .orange : item.diets.contains(.carbControl) ? .yellow : .blue)
//                        .overlay(
//                            Circle()
//                                .stroke(Color.black)
//                        )
                        .padding(.bottom, 3)
                    Image(systemName: "circle.fill")
                        .foregroundStyle(item.diets.contains(.renal) || item.diets.contains(.cardiac) ? .gray : Color(.systemBackground))
//                        .overlay(
//                            Circle()
//                                .stroke(Color.black)
//                        )
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    let item = MenuItem(name: "Test", nutrition: "Nutrition details", mealTimes: [MealTime.breakfast], dishType: DishType.main, diets: [.carbControl, .cardiac])
    ItemView(item: item)
}
