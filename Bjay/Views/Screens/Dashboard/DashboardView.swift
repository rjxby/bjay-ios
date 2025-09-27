//
//  DashboardView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//  Updated 2025-09-27.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @ObservedObject private var coordinator: NavigationCoordinator

    init(viewModel: DashboardViewModel, coordinator: NavigationCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                GradientBackgroundView(colors: [
                    Color.pink.opacity(0.2),
                    Color.blue.opacity(0.3)
                ])
                .ignoresSafeArea()

                content
                    .task {
                        await viewModel.fetchActivities()
                    }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .activityTypeSelection: coordinator.makeActivityTypeSelectionView?()
                case .feed: coordinator.makeFeedView?()
                case .sleep: coordinator.makeSleepView?()
                case .diaper: coordinator.makeDiaperView?()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { filterMenu }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: Route.activityTypeSelection) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }

    // MARK: - Main Content

    private var content: some View {
        Group {
            if let _ = viewModel.errorMessage {
                errorView
            } else if viewModel.activities.isEmpty && !viewModel.isLoading {
                emptyView
            } else {
                activitiesList
            }
        }
    }

    // MARK: - Activities List with Header

    private var activitiesList: some View {
        List {
            Section(header: headerView.padding(.horizontal).padding(.top, 8)) {
                ForEach(viewModel.activities) { activity in
                    ActivityCardView(activity: activity)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init())
                        .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    Task { await viewModel.deleteActivities(at: indexSet) }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .refreshable {
            Task { await viewModel.refreshActivities() }
        }
        .overlay {
            if viewModel.isLoading && viewModel.activities.isEmpty {
                shimmerPlaceholder
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Text("Ate \(viewModel.todayFeedingAmount, specifier: "%.2f") oz")
                .font(.headline)
            Spacer()
            Text("Next Feeding: \(viewModel.nextFeedingTime, style: .time)")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.green.opacity(0.8))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .padding(.bottom, 8)
    }

    // MARK: - Shimmer Placeholder

    private var shimmerPlaceholder: some View {
        VStack(spacing: 12) {
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .frame(height: 80)
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
        .padding()
    }

    // MARK: - Error & Empty Views

    private var errorView: some View {
        VStack(spacing: 10) {
            Text("Error")
                .font(.headline)
                .foregroundColor(.red)
            if let message = viewModel.errorMessage?.message {
                Text(message)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private var emptyView: some View {
        VStack {
            Text("No Activities")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Start adding activities by tapping the + button.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    // MARK: - Filter Menu

    private var filterMenu: some View {
        Menu {
            Picker("Filter", selection: $viewModel.filter) {
                Label("All", systemImage: "line.3.horizontal.decrease.circle")
                    .tag(ActivityType?.none)
                Label(ActivityType.feed.stringValue.capitalized, systemImage: ActivityType.feed.iconName)
                    .tag(ActivityType?.some(.feed))
                Label(ActivityType.sleep.stringValue.capitalized, systemImage: ActivityType.sleep.iconName)
                    .tag(ActivityType?.some(.sleep))
                Label(ActivityType.diaper.stringValue.capitalized, systemImage: ActivityType.diaper.iconName)
                    .tag(ActivityType?.some(.diaper))
            }
        } label: {
            let title = viewModel.filter?.stringValue.capitalized ?? "Filter"
            let icon = viewModel.filter?.iconName ?? "line.3.horizontal.decrease.circle"
            Label(title, systemImage: icon)
        }
    }
}

// MARK: - Shimmer Modifier

extension View {
    func shimmering(duration: Double = 1.2, bounce: Bool = false) -> some View {
        modifier(ShimmerModifier(duration: duration, bounce: bounce))
    }
}

fileprivate struct ShimmerModifier: ViewModifier {
    let duration: Double
    let bounce: Bool

    @State private var animate = false

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    let gradient = LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.0), location: 0.0),
                            .init(color: Color.white.opacity(0.4),  location: 0.5),
                            .init(color: Color.white.opacity(0.0), location: 1.0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )

                    Rectangle()
                        .fill(gradient)
                        .frame(width: geo.size.width * 1.6, height: geo.size.height)
                        .offset(x: animate ? geo.size.width * 0.8 : -geo.size.width * 0.8)
                        .allowsHitTesting(false)
                        .onAppear {
                            withAnimation(.linear(duration: duration).repeatForever(autoreverses: bounce)) {
                                animate = true
                            }
                        }
                }
                .mask(content)
            )
    }
}

// MARK: - Preview

#Preview {
    let repositoryMock = ActivityRepositoryMock()
    DashboardView(
        viewModel: DashboardViewModel(repository: repositoryMock),
        coordinator: NavigationCoordinator()
    )
}
