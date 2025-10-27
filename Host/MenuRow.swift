//
//  MenuRow.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/26/25.
//

import SwiftUI

struct MenuRow: View {
    let item: MenuItem
    
    var body: some View {
        HStack(spacing: 12){
            if item.isSpecial {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.nutrition)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        
        .padding(.vertical, 4)
    }
}

//#Preview {
//    MenuRow()
//}
