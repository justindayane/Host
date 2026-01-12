//
//  CreateTrayView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 12/22/25.
//

import SwiftUI

struct CreateTrayView: View {
    @State private var selectedDiet: Diet = .regular
    @State private var selectedMealTime: MealTime = .breakfast
    @Environment(\.dismiss) var dismiss
    var onComplete : (Tray) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select diet" , selection: $selectedDiet) {
                        ForEach(Diet.allCases, id:\.self) { diet in
                            HStack {
                                DietKitIndicator(diet: diet) //This change is not reflecting in the ui
                                Text(diet.title)
                            }
                            .tag(diet)
                        }
                    }
//                    .pickerStyle(.menu)
                }
                
                Section {
                    Picker("Select Meal Time", selection: $selectedMealTime) {
                        ForEach(MealTime.allCases, id: \.self) { time in
                            Text(time.rawValue.capitalized)
                                .tag(time)
                        }
                    }
//                    .pickerStyle(.navigationLink)
                }
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            DietKitIndicator(diet: selectedDiet, size: 16)
                            Text("Creating:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text("\(selectedMealTime.rawValue.capitalized) \(selectedDiet.title) Tray")
                            .font(.headline)
                    }
                }

                Section {
                    Button("Create Tray") {
                        let tray = Tray(diet: selectedDiet, time: selectedMealTime)
                        onComplete(tray)
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Tray")
            .toolbar {
                ToolbarItem {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    CreateTrayView(onComplete: { tray in
        print("Preview created a \(tray.diet.title) tray")
    } )
}
