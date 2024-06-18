//
//  ColorExtension.swift
//  LuxeCab
//
//  Created by JJMac on 18/06/24.
//

import Foundation
import SwiftUI

struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
}

extension Color {
    static let theme = ColorTheme()
}
