//
//  CustomColor.swift
//  Untime
//
//  Created by Jan Baumann on 06.12.21.
//

import SwiftUI

struct CustomColor: View {
    var rgb: [Double] = [255, 255, 255]
    var opacity = 1.0
    
    var body: some View {
        Color(.sRGB, red: rgb[0] / 255, green: rgb[1] / 255, blue: rgb[2] / 255, opacity: 1)
    }
    
    func getColor() -> Color {
        return Color(.sRGB, red: rgb[0], green: rgb[1], blue: rgb[2], opacity: 1)
    }
}

struct CustomColor_Previews: PreviewProvider {
    static var previews: some View {
        CustomColor()
    }
}
