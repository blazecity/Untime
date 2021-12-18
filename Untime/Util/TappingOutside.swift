//
//  TappingOutside.swift
//  Untime
//
//  Created by Jan Baumann on 06.12.21.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
