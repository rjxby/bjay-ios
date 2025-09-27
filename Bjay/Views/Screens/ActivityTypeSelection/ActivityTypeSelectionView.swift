//
//  ActivityTypeSelectionView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

struct ActivityTypeSelectionView: View {
    @ObservedObject private var coordinator: NavigationCoordinator
    
    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundView(colors: [Color.blue.opacity(0.2), Color.pink.opacity(0.3)])
            
            ScrollView {
                VStack(spacing: 16) {
                    activityLink(type: .feed, color: .green)
                    activityLink(type: .sleep, color: .blue)
                    activityLink(type: .diaper, color: .orange)
                }
                .padding(.horizontal)
                .frame(maxWidth: 500)
            }
        }
        .navigationTitle("Select Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Activity Link (row + navigation)
    @ViewBuilder
    private func activityLink(type: ActivityType, color: Color) -> some View {
        NavigationLink(value: type.route) {
            HStack(spacing: 30) {
                ActivityTypeIconView(activityType: type)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 5) {
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
        }
    }
}

#Preview {
    ActivityTypeSelectionView(coordinator: NavigationCoordinator())
}
