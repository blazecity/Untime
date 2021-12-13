//
//  StringValidator.swift
//  Untime
//
//  Created by Jan Baumann on 13.12.21.
//

import Foundation

class StringValidator {
    static func validate(str: String) -> Bool {
        let strTrimmed = str.trimmingCharacters(in: .whitespaces)
        return strTrimmed.split(separator: " ").count != 0
    }
    
    static func validate(strArr: [String]) -> Bool {
        for str in strArr {
            if !validate(str: str) { return false }
        }
        return true
    }
}
