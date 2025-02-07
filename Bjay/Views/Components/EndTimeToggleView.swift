//
//  EndTimeToggleView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

import SwiftUI

struct EndTimeToggleView: View {
    @Binding var includeEndTime: Bool
    @Binding var endTime: Date?
    
    var isDisabled: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Toggle(isOn: $includeEndTime.animation()) {
                Text("Add End Time")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .disabled(isDisabled)
            .padding(.horizontal)
            .onChange(of: includeEndTime) { _, includeEndTime in
                if includeEndTime && endTime == nil {
                    endTime = Date()
                } else if !includeEndTime {
                    endTime = nil
                }
            }
            
            if includeEndTime  {
                TimePickerView(
                    label: "End At",
                    isDisabled: isDisabled,
                    date: Binding(
                        get: { endTime ?? Date() },
                        set: { newDate in endTime = newDate }
                    )
                )
            }
        }
    }
}

#Preview {
    EndTimeToggleView(includeEndTime: .constant(true), endTime: .constant(Date()), isDisabled: false)
}
