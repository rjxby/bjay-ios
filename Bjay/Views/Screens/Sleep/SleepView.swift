//
//  SleepView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

struct SleepView: View {
    @StateObject private var viewModel: SleepViewModel
    @ObservedObject private var coordinator: NavigationCoordinator
    
    init(viewModel: SleepViewModel, coordinator: NavigationCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundView(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.3)])
            
            VStack(spacing: 20) {
                TimePickerView(label: "Start At", isDisabled: viewModel.isSaving, date: $viewModel.startTime)
                
                EndTimeToggleView(includeEndTime: $viewModel.includeEndTime, endTime: $viewModel.endTime, isDisabled: viewModel.isSaving)
                
                SaveButtonView(
                    bodyColor: .blue,
                    action: { Task { await viewModel.saveSleep() } },
                    isSaving: $viewModel.isSaving
                )
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sleep")
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
    SleepViewPreview()
}

struct SleepViewPreview: View {
    @State private var path: [Route] = []
    
    let repository = ActivityRepositoryMock()
    let coordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $path) {
            SleepView(viewModel: SleepViewModel(repository: repository), coordinator: coordinator)
        }
    }
}
