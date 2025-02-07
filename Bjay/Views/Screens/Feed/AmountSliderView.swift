//
//  AmountSliderView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

import SwiftUI

struct AmountSliderView: View {
    @Binding var amount: Double
    
    var isDisabled: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(String(format: "%.2f", amount)) oz")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.blue)
            
            Slider(value: $amount, in: 0.5...10, step: 0.25)
                .accentColor(.blue)
                .padding(.horizontal)
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.5 : 1.0)
                .animation(.spring(), value: amount)
        }
    }
}

#Preview {
    AmountSliderView(amount: .constant(1.0), isDisabled: false)
}
