//
//  ActivityCardView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

import SwiftUI

struct ActivityCardView: View {
    let activity: Activity
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ActivityTypeIconView(activityType: activity.type)
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack{
                    Text(activity.type.stringValue.capitalized)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if activity.type == .feed, let amount = activity.amount {
                        Text("\(String(format: "%.2f", amount)) oz")
                            .font(.caption)
                            .foregroundColor(activity.type.iconBackgroundColor)
                            .padding(4)
                            .cornerRadius(5)
                    }
                    
                    if case let .diaper(meta) = activity.meta {
                        Text(diaperTypeLabel(for: meta.type))
                            .font(.caption)
                            .foregroundColor(activity.type.iconBackgroundColor)
                            .padding(4)
                            .cornerRadius(5)
                    }
                }
                
                Text(activity.startTime, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if let endTime = activity.endTime {
                    VStack (spacing: 4) {
                        Text(formattedTime(activity.startTime))
                            .font(.subheadline)
                            .foregroundColor(activity.type.iconBackgroundColor)
                        Text(formattedTime(endTime))
                            .font(.subheadline)
                            .foregroundColor(activity.type.iconBackgroundColor)
                    }
                } else {
                    Text(formattedTime(activity.startTime))
                        .font(.subheadline)
                        .foregroundColor(activity.type.iconBackgroundColor)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("CardBackgroundAdaptiveColor")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func diaperTypeLabel(for type: DiaperType) -> String {
        type.displayName.lowercased()
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ActivityCardView(activity: Activity(id: UUID().uuidString, accountId: UUID().uuidString, type: .diaper, startTime: Date(), endTime: nil, amount: 1, meta: ActivityMeta.diaper(DiaperMeta(type: .wet)))).preferredColorScheme(.light)
    ActivityCardView(activity: Activity(id: UUID().uuidString, accountId: UUID().uuidString, type: .sleep, startTime: Date(), endTime: Date(), amount: 1, meta: nil)).preferredColorScheme(.light)
}
