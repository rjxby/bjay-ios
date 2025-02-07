//
//  DiaperTypePickerView.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/15/25.
//

import SwiftUI

struct DiaperTypePickerView: View {
    @Binding var selectedDiaperType: DiaperType
    var isDisabled: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(DiaperType.allCases, id: \.self) { type in
                Text(type.displayName)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor(for: type))
                    .foregroundColor(foregroundColor(for: type))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(borderColor(for: type), lineWidth: 1)
                    )
                    .scaleEffect(selectedDiaperType == type ? 1.05 : 1.0)
                    .onTapGesture {
                        guard !isDisabled else { return }
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.2)) {
                            selectedDiaperType = type
                        }
                    }
            }
        }
        .padding(.vertical, 10)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    private func backgroundColor(for type: DiaperType) -> Color {
        selectedDiaperType == type ? Color.orange : Color.gray.opacity(0.2)
    }
    
    private func foregroundColor(for type: DiaperType) -> Color {
        selectedDiaperType == type ? .white : .primary
    }
    
    private func borderColor(for type: DiaperType) -> Color {
        selectedDiaperType == type ? Color.orange : Color.gray
    }
}

#Preview {
    VStack {
        DiaperTypePickerView(selectedDiaperType: .constant(.wet), isDisabled: false)
    }
}
