//
//  MultiSelectToggle.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/29/25.
//

import SwiftUI

// --- This is REUSABLE --- A toggle that keeps a 'Set<Element>' in sync with a single enum value.


struct MultiSelectToggle<Element: Hashable & RawRepresentable & CaseIterable & Identifiable>: View where Element.RawValue == String  {
    @Binding var selection: Set<Element>
    var element: Element
    
    var body: some View {
        Toggle(element.rawValue.capitalized, isOn: Binding(get: {
            selection.contains(element)
        }, set: { newValue in
            if newValue {
                // Insert – we ignore the returned tuple
                _ = selection.insert(element)
            } else {
                // Remove – we ignore the returned Element?
                _ = selection.remove(element)
            }
        }))
    }
}

