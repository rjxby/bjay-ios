//
//  IconView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

import SwiftUI

struct ActivityTypeIconView: View {
    let activityType: ActivityType
    
    @State private var isTapped = false

    var body: some View {
        ZStack {
            Circle()
                .fill(activityType.iconBackgroundColor)
                .frame(width: isTapped ? 55 : 50, height: isTapped ? 55 : 50)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isTapped)
                .onTapGesture {
                    isTapped.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isTapped = false
                    }
                }
            Image(systemName: activityType.iconName)
                .font(.title2)
                .foregroundColor(.white)
        }
    }
}

extension ActivityType {
    var iconName: String {
        switch self {
        case .feed: return "fork.knife"
        case .sleep: return "bed.double.fill"
        case .diaper: return "drop.fill"
        }
    }
    
    var iconBackgroundColor: Color {
        switch self {
        case .feed: return .green
        case .sleep: return .blue
        case .diaper: return .orange
        }
    }
}

#Preview {
    ActivityTypeIconView(activityType: .feed)
}
