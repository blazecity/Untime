//
//  TextSizeView.swift
//  Untime
//
//  Created by Jan Baumann on 06.12.21.
//

import SwiftUI

struct CustomText: View {
    @Binding var text: String
    var size: CGFloat = 10
    var bold: Bool = false
    var color: Color = .black
    
    var body: some View {
        var txt = Text(text).font(.system(size: size)).foregroundColor(color)
        if bold {
            txt = txt.bold()
        }
        return txt
    }
}

struct TextSizeView_Previews: PreviewProvider {
    @State static var text = "Hello"
    
    static var previews: some View {
        CustomText(text: $text, size: 10, bold: true, color: .red)
    }
}
