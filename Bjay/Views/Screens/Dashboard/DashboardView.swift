//
//  DashboardView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
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
                GradientBackgroundView(colors: [Color.pink.opacity(0.2), Color.blue.opacity(0.3)])
                
                VStack {
                    if viewModel.isLoading {
                        LoadingView()
                            .transition(.opacity)
                            .padding()
                    }
                    else if let errorMessage = viewModel.errorMessage {
                        VStack(spacing: 10) {
                            Text("Error")
                                .font(.headline)
                                .foregroundColor(.red)
                            Text(errorMessage.message)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    else if viewModel.activities.isEmpty {
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
                    else {
                        HStack {
                            Text("Ate \(viewModel.todayFeedingAmount, specifier: "%.2f") oz")
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
                        
                        List {
                            ForEach(viewModel.activities.sorted(by: { $0.startTime > $1.startTime })) { activity in
                                ActivityCardView(activity: activity)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                                    .padding(.vertical, 4)
                            }
                            .onDelete { indexSet in
                                Task {
                                    await viewModel.deleteActivities(at: indexSet)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .refreshable{
                            Task {
                                await viewModel.refreshActivities()
                            }
                            
                        }
                    }
                }
                .padding(.horizontal)
                .task {
                    await viewModel.fetchActivities(page: 1, pageSize: 10)
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .activityTypeSelection:
                    coordinator.createActivityTypeSelectionView()
                case .feed:
                    coordinator.createFeedView()
                case .sleep:
                    coordinator.createSleepView()
                case .diaper:
                    coordinator.createDiaperView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Filter", selection: $viewModel.filter) {
                            Label(ActivityType.feed.stringValue.capitalized, systemImage: ActivityType.feed.iconName).tag(ActivityType.feed)
                            
                            Label(ActivityType.sleep.stringValue.capitalized, systemImage: ActivityType.sleep.iconName).tag(ActivityType.sleep)
                            
                            Label(ActivityType.diaper.stringValue.capitalized, systemImage: ActivityType.diaper.iconName).tag(ActivityType.diaper)
                        }
                        .task {
                            await viewModel.fetchActivities(page: 1, pageSize: 10, filter: viewModel.filter)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: Route.activityTypeSelection) {
                        AddActivityIconButtonView()
                    }
                }
            }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    let repositoryMock = ActivityRepositoryMock()
    DashboardView(viewModel: DashboardViewModel(repository: repositoryMock), coordinator: NavigationCoordinator(repository: repositoryMock)).preferredColorScheme(.light)
}
