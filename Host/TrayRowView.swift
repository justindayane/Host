//
//  TrayRowView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 12/17/25.
//

import SwiftUI

struct TrayRowView: View {
    let tray: Tray
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                DietKitIndicator(diet: tray.diet, size: 14)
                
                Text(tray.diet.title)
                    .font(.headline)
            }
            
            HStack {
                Text("\(tray.itemCount) item(s)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(tray.createdAt.formatted(.relative(presentation: .named)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TrayRowView(tray: Tray(diet: .carbControl, time: .lunch, items: [MenuItem(name: "Test", nutrition: "nutrition", mealTimes: [.dinner, .lunch], dishType: .main)]))
}
