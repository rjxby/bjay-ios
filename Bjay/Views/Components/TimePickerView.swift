//
//  TimePicker.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

import SwiftUI

struct TimePickerView: View {
    let label: String
    var isDisabled: Bool
    
    @Binding var date: Date
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Spacer()
                
                Text(label)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.leading, 5)
                
                Text("\(formattedTime(date: date))")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.blue)
                    .padding(.trailing, 5)
            }
            
            DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .frame(maxWidth: .infinity)
                .background(Color.clear)
                .cornerRadius(10)
                .shadow(radius: 0)
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.5 : 1.0)
        }
    }
    
    private func formattedTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    TimePickerView(label: "Date", isDisabled: false, date: .constant(Date()))
}
