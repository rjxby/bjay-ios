//
//  FeedViewModel.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    @Published var amount: Double = 1.0
    @Published var startTime: Date = Date()
    @Published var endTime: Date? = nil
    @Published var includeEndTime: Bool = false
    @Published var isSaving = false
    @Published var shouldNavigate = false
    @Published var errorMessage: IdentifiableError? = nil
    
    private let repository: ActivityRepositoryProtocol
    
    init(repository: ActivityRepositoryProtocol) {
        self.repository = repository
    }
    
    func saveFeed() async {
        guard !isSaving else { return }
        isSaving = true
        defer { isSaving = false }
        
        do {
            let newActivity = NewActivity(type: .feed,
                                          startTime: startTime,
                                          endTime: includeEndTime ? endTime : nil,
                                          amount: amount,
                                          meta: nil)
            try await repository.addActivity(newActivity: newActivity)
            shouldNavigate = true
        } catch {
            errorMessage = IdentifiableError(message: "Failed to save: \(error.localizedDescription)")
        }
    }
}
