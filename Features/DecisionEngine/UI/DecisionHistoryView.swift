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
                    DisclosureGroup {
                        Text("Selected Items:")
                        ForEach(log.selectedItemNames, id: \.self) { item in
                            Text(item)
                                .font(.caption)
                        }
                    } label: {
                        VStack (alignment: .leading) {
                            Text("\(log.mealTime.rawValue.capitalized) Tray Decision")
                                .font(.headline)
                            HStack {
                                Text(log.timestamp.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(log.wasDefault ? "Default" : "Custom")
                                    .foregroundStyle(log.wasDefault ? .blue : .orange)
                                    .font(.caption)
                            }
                            Text(log.constraintNames.joined(separator: ", "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
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
