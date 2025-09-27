//
//  DiaperView.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

struct DiaperView: View {
    @StateObject private var viewModel: DiaperViewModel
    @ObservedObject private var coordinator: NavigationCoordinator
    
    init(viewModel: DiaperViewModel, coordinator: NavigationCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundView(colors: [Color.orange.opacity(0.2), Color.blue.opacity(0.3)])
            
            VStack(spacing: 20) {
                TimePickerView(label: "At", isDisabled: viewModel.isSaving, date: $viewModel.startTime)
                
                DiaperTypePickerView(
                    selectedDiaperType: $viewModel.selectedDiaperType,
                    isDisabled: viewModel.isSaving
                )
                
                SaveButtonView(
                    bodyColor: .orange,
                    action: { Task { await viewModel.saveDiaper() } },
                    isSaving: $viewModel.isSaving
                )
                
                Spacer()
            }
            .padding()
            .navigationTitle("Diaper")
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
    DiaperViewPreview()
}

struct DiaperViewPreview: View {
    @State private var path: [Route] = []
    
    let repository = ActivityRepositoryMock()
    let coordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $path) {
            DiaperView(viewModel: DiaperViewModel(repository: repository), coordinator: coordinator)
        }
    }
}
