//
//  ConstraintType.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/24/26.
//

import Foundation

/// Category of dietary constraint
enum ConstraintType: Codable {
    case medical // Evaluated by numbers
    case preference // Evaluated by tags
}
