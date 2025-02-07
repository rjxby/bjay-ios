//
//  AddActivityIconButtonView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

import SwiftUI

struct AddActivityIconButtonView: View {
    let icon: String = "plus.circle"
    let color: Color = .accentColor
    var size: CGFloat = 42
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: size, height: size)
            
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(color)
        }
        .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AddActivityIconButtonView()
}
