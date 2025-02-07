//
//  SaveButtonView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

import SwiftUI

struct SaveButtonView: View {
    var bodyColor: Color = .green
    var action: () -> Void
    
    @Binding var isSaving: Bool
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                scale = 0.95
            }
            action()
        }) {
            if isSaving {
                ProgressView()
                    .transition(.opacity)
            } else {
                Text("Add")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isSaving ? Color.gray : bodyColor)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .scaleEffect(scale)
                    .onAppear {
                        scale = 1.0
                    }
            }
        }
        .disabled(isSaving)
        .padding(20)
    }
}

#Preview {
    SaveButtonView(action: {}, isSaving: .constant(false))
}
