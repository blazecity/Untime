//
//  ColorConverter.swift
//  Untime
//
//  Created by Jan Baumann on 08.12.21.
//

import Foundation
import SwiftUI
import CoreData

class ColorConverter {
    static func convertFromTColor(_ tColor: TColor) -> Color {
        let rgb = [tColor.red, tColor.green, tColor.blue]
        return CustomColor(rgb: rgb, opacity: 1).getColor()
    }
    
    static func convertToTColor(_ color: Color, viewContext: NSManagedObjectContext) -> TColor {
        let newColor = TColor(context: viewContext)
        let tagColor = UIColor(color)
        var colorRed: CGFloat = 0
        var colorGreen: CGFloat = 0
        var colorBlue: CGFloat = 0
        var colorAlpha: CGFloat = 0
        tagColor.getRed(&colorRed, green: &colorGreen, blue: &colorBlue, alpha: &colorAlpha)
        newColor.red = Double(colorRed)
        newColor.green = Double(colorGreen)
        newColor.blue = Double(colorBlue)
        return newColor
    }
}
