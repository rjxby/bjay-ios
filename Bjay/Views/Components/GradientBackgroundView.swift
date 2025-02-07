//
//  GradientBackgroundView.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/1/25.
//

import SwiftUI

struct GradientBackgroundView: View {
    let colors: [Color]
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
