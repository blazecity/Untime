//
//  DateFormatter.swift
//  Untime
//
//  Created by Jan Baumann on 12.12.21.
//

import Foundation

class Formatter {
    static func formatDate(date: Date) -> String {
        let formatter = getFormatter()
        return formatter.string(from: date)
    }
    
    static func sortDateStrings(dateStrings: [String]) -> [String] {
        let formatter = getFormatter()
        let sortedArray = dateStrings.sorted {formatter.date(from: $0)! > formatter.date(from: $1)!}
        return sortedArray
    }
    
    private static func getFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}
