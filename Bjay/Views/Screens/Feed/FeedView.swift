//
//  FeedView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    init(viewModel: FeedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundView(colors: [Color.green.opacity(0.2), Color.blue.opacity(0.3)])
            
            VStack(spacing: 20) {
                AmountSliderView(amount: $viewModel.amount, isDisabled: viewModel.isSaving)
                
                TimePickerView(label: "Start At", isDisabled: viewModel.isSaving, date: $viewModel.startTime)
                
                EndTimeToggleView(includeEndTime: $viewModel.includeEndTime, endTime: $viewModel.endTime, isDisabled: viewModel.isSaving)
                
                SaveButtonView(
                    bodyColor: .green,
                    action: { Task { await viewModel.saveFeed() } },
                    isSaving: $viewModel.isSaving
                )
                
                Spacer()
            }
            .padding()
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: viewModel.shouldNavigate) { _, shouldNavigate in
            if shouldNavigate {
                withAnimation(.spring()) {
                    coordinator.popToRoot()
                }
            }
        }
        .alert(item: $viewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    FeedViewPreview()
}

struct FeedViewPreview: View {
    @State private var path: [Route] = []
    
    let repository = ActivityRepositoryMock()
    
    var body: some View {
        NavigationStack(path: $path) {
            FeedView(viewModel: FeedViewModel(repository: repository))
                .environmentObject(NavigationCoordinator(repository: repository))
        }
    }
}
