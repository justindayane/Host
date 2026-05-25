//
//  DietKitIndicator.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/8/26.
//

import SwiftUI

struct DietKitIndicator: View {
    let diet: Diet
    var size: CGFloat = 16
    
    var body: some View {
        Circle()
            .fill(diet.kitColor)
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .strokeBorder(Color.white, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    DietKitIndicator(diet: .renal, size: 32)
}
