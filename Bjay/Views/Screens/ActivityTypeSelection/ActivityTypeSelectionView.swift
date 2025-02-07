//
//  ActivityTypeSelectionView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

struct ActivityTypeSelectionView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    var body: some View {
        ZStack {
            GradientBackgroundView(colors: [Color.blue.opacity(0.2), Color.pink.opacity(0.3)])
            
            VStack(spacing: 16) {
                NavigationLink(value: Route.feed) {
                    activityRow(type: .feed, color: .green)
                }
                
                NavigationLink(value: Route.sleep) {
                    activityRow(type: .sleep, color: .blue)
                }
                
                NavigationLink(value: Route.diaper) {
                    activityRow(type: .diaper, color: .orange)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Select Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func activityRow(type: ActivityType, color: Color) -> some View {
        HStack {
            ActivityTypeIconView(activityType: type)
                .frame(width: 50, height: 50)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(type.stringValue.capitalized)
                    .font(.headline)
                    .foregroundColor(color)
                
                Text("Tap to log \(type.stringValue.lowercased()) activity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
        )
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        .scaleEffect(1.0)
        .animation(.spring(), value: type)
    }
}
//
//#Preview {
//    ActivityTypeSelectionViewPreview()
//}
//
//struct ActivityTypeSelectionViewPreview: View {
//    @State private var path: [Route] = []
//    
//    var body: some View {
//        ActivityTypeSelectionView(
//            path: $path
//        )
//    }
//}
