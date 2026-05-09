//
//  DecisionHistoryView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/9/26.
//

import SwiftUI

struct DecisionHistoryView: View {
    @ObservedObject var history: DecisionHistory
    
    var body: some View {
        if history.logs.isEmpty {
            ContentUnavailableView("No Decision History", systemImage: "list.bullet.clipboard", description: Text("Decision History will be displayed here."))
        }
        else {
            List {
                ForEach(history.logs) { log in
                    DisclosureGroup() {
                        Text("Selected Items:")
                        ForEach(log.selectedItemNames, id: \.self) { item in
                            Text(item)
                        }
                    } label: {
                        VStack {
                            Text("\(log.mealTime.rawValue.capitalized)")
                            Text(log.timestamp, style: .date)
                            Text(log.wasDefault ? "Default" : "Custom")
                            Text(log.constraintNames.joined(separator: ", "))
                        }
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    DecisionHistoryView()
//}
