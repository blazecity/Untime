//
//  DateFormatter.swift
//  Untime
//
//  Created by Jan Baumann on 12.12.21.
//

import Foundation

class Formatter {
    static func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
