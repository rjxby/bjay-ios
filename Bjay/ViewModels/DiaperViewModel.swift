//
//  DiaperViewModel.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

@MainActor
class DiaperViewModel: ObservableObject {
    @Published var startTime: Date = Date()
    @Published var shouldNavigate = false
    @Published var isSaving = false
    @Published var errorMessage: IdentifiableError? = nil
    @Published var selectedDiaperType: DiaperType = .wet

    private let repository: ActivityRepositoryProtocol
    
    init(repository: ActivityRepositoryProtocol) {
        self.repository = repository
    }
    
    func saveDiaper() async {
        guard !isSaving else { return }
        isSaving = true
        defer { isSaving = false }
        
        do {
            let meta = ActivityMeta.diaper(DiaperMeta(type: selectedDiaperType))
            let newActivity = NewActivity(
                type: .diaper,
                startTime: startTime,
                endTime: nil,
                amount: 1,
                meta: meta)
            try await repository.addActivity(newActivity: newActivity)
            shouldNavigate = true
        } catch {
            errorMessage = IdentifiableError(message: "Failed to save: \(error.localizedDescription)")
        }
    }
}
