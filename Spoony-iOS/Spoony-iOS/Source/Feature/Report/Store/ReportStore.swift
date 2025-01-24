//
//  ReportStore.swift
//  Spoony-iOS
//
//  Created by 최주리 on 1/22/25.
//

import Foundation

final class ReportStore: ObservableObject {
    private let network: ReportProtocol = DefaultReportService()
    
    @Published private(set) var state: ReportState = ReportState()
    
    func dispatch(_ intent: ReportIntent) {
        switch intent {
        case .reportReasonButtonTapped(let report):
            changeReportType(report: report)
        case .reportPostButtonTapped(let postId):
            sendReport(postId: postId, description: state.description)
        case .descriptionChanged(let newValue):
            state.description = newValue
        case .backgroundTapped: break
        case .isErrorChanged(let newValue):
            state.isError = newValue    
        }
    }
}

extension ReportStore {
    private func changeReportType(report: ReportType) {
        state.selectedReport = report
    }
    
    private func sendReport(postId: Int, description: String) {
        Task {
            try await postReport(postId: postId, description: description)
        }
    }
    
    // MARK: - Network
    func postReport(
        postId: Int,
        description: String
    ) async throws {
        try await network.reportPost(
            postId: postId,
            report: state.selectedReport,
            description: description
        )
    }
}
