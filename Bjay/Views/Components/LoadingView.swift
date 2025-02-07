//
//  LoadingView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.blue.opacity(0.6)]),
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .animation(.linear(duration: 1.5).repeatForever(autoreverses: true), value: animate)
        .onAppear {
            animate = true
        }
        .mask(
            Text("Loading...")
                .font(.headline)
                .padding()
        )
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

#Preview {
    LoadingView()
}
